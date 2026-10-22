/* FL-41: GAME.EXE functions at or above 0x480000, translated instruction by instruction by scripts/lift_fl41.py (see original_methods_fl41.h for the model).
 * GENERATED: regenerate with scripts/fl41_generate.py; do not edit by hand. Each symbol `m<va>_lifted` is the original function at <va>; the comment above
 * it gives the address and the size. These are machine translations: they carry no names and no restructuring of the original. */
#include "original_methods_fl41.h"

/* GAME.EXE 0x48ad26 (223 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m48ad26_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x48ad26: push ebp */
    ebp = esp;  /* 0x48ad27: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x10u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x48ad29: sub esp, 0x10 */
    esp -= 4u; WR32(esp, esi);  /* 0x48ad2c: push esi */
    esp -= 4u; WR32(esp, edi);  /* 0x48ad2d: push edi */
    WR32((uint32_t)(ebp + 0xfffffff0u), ecx);  /* 0x48ad2e: mov dword ptr [ebp - 0x10], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x48ad31: mov eax, dword ptr [ebp - 0x10] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x1eu)))) & 0xffffffffu;  /* 0x48ad34: movsx ecx, word ptr [eax + 0x1e] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x48ad38: imul ecx, ecx, 0x8d */
    edx = RD32((uint32_t)(ecx + 0x5bb5e5u));  /* 0x48ad3e: mov edx, dword ptr [ecx + 0x5bb5e5] */
    WR32((uint32_t)(ebp + 0xfffffff8u), edx);  /* 0x48ad44: mov dword ptr [ebp - 8], edx */
    WR32((uint32_t)(ebp + 0xfffffffcu), 0x0u);  /* 0x48ad47: mov dword ptr [ebp - 4], 0 */
    goto L_48ad59;  /* 0x48ad4e: jmp 0x48ad59 */
L_48ad50:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x48ad50: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x48ad53: add eax, 1 */
    WR32((uint32_t)(ebp + 0xfffffffcu), eax);  /* 0x48ad56: mov dword ptr [ebp - 4], eax */
L_48ad59:
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x48ad59: mov ecx, dword ptr [ebp - 8] */
    { uint32_t a_ = edx, b_ = edx, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); edx = r_; }  /* 0x48ad5c: xor edx, edx */
    edx = (edx & 0xffffff00u) | ((RD8((uint32_t)(ecx + 0x21u))) & 0xffu);  /* 0x48ad5e: mov dl, byte ptr [ecx + 0x21] */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffffcu)), b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x48ad61: cmp dword ptr [ebp - 4], edx */
    if ((sf == of)) goto L_48ad7f;  /* 0x48ad64: jge 0x48ad7f */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x48ad66: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x48ad69: mov ecx, dword ptr [ebp - 0x10] */
    WR16((uint32_t)(ecx + eax * 2u + 0x2eu), 0xffffu);  /* 0x48ad6c: mov word ptr [ecx + eax*2 + 0x2e], 0xffff */
    edx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x48ad73: mov edx, dword ptr [ebp - 0x10] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ebp + 0xfffffffcu)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x48ad76: add edx, dword ptr [ebp - 4] */
    WR8((uint32_t)(edx + 0x24u), 0x0u);  /* 0x48ad79: mov byte ptr [edx + 0x24], 0 */
    goto L_48ad50;  /* 0x48ad7d: jmp 0x48ad50 */
L_48ad7f:
    eax = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x48ad7f: mov eax, dword ptr [ebp - 0x10] */
    WR16((uint32_t)(eax + 0x42u), 0x0u);  /* 0x48ad82: mov word ptr [eax + 0x42], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x48ad88: mov ecx, dword ptr [ebp - 0x10] */
    WR32((uint32_t)(ecx + 0x44u), 0x0u);  /* 0x48ad8b: mov dword ptr [ecx + 0x44], 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x48ad92: mov edx, dword ptr [ebp - 0x10] */
    WR32((uint32_t)(edx + 0x4eu), 0x1u);  /* 0x48ad95: mov dword ptr [edx + 0x4e], 1 */
    eax = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x48ad9c: mov eax, dword ptr [ebp - 0x10] */
    WR32((uint32_t)(eax + 0x1a6u), 0x1u);  /* 0x48ad9f: mov dword ptr [eax + 0x1a6], 1 */
    { uint32_t a_ = RD32((uint32_t)(0x5bb1cau)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x48ada9: cmp dword ptr [0x5bb1ca], 0 */
    if (zf) goto L_48adff;  /* 0x48adb0: je 0x48adff */
    edi = 0x54e370u;  /* 0x48adb2: mov edi, 0x54e370 */
    esi = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x48adb7: mov esi, dword ptr [ebp - 8] */
    { uint32_t a_ = esi, b_ = 0x375u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esi = r_; }  /* 0x48adba: add esi, 0x375 */
    ecx = 0x9u;  /* 0x48adc0: mov ecx, 9 */
    { uint32_t a_ = edx, b_ = edx, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); edx = r_; }  /* 0x48adc5: xor edx, edx */
    /* 0x48adc7: repe cmpsb byte ptr [esi], byte ptr es:[edi] */
    while (ecx != 0u) {
    { uint32_t a_ = RD8(esi), b_ = RD8(edi), r_;
    FL41_SUB(a_, b_, 0u, r_, 8); }
    esi += 1u; edi += 1u;
    ecx -= 1u;
    if (!zf) break;
    }
    if (zf) goto L_48adff;  /* 0x48adc9: je 0x48adff */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x48adcb: mov eax, dword ptr [ebp - 8] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x396u)))) & 0xffffffffu;  /* 0x48adce: movsx ecx, word ptr [eax + 0x396] */
    WR32((uint32_t)(ebp + 0xfffffff4u), ecx);  /* 0x48add5: mov dword ptr [ebp - 0xc], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x48add8: mov edx, dword ptr [ebp - 0xc] */
    esp -= 4u; WR32(esp, edx);  /* 0x48addb: push edx */
    ecx = 0x5cf1ebu;  /* 0x48addc: mov ecx, 0x5cf1eb */
    esp -= 4u; WR32(esp, 0x48ade6u); FL41_CALL(0x4f6334u); esp += 4u; esp += 4u;  /* 0x48ade1: call 0x4f6334 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x48ade6: test eax, eax */
    if (!zf) goto L_48adff;  /* 0x48ade8: jne 0x48adff */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x48adea: mov eax, dword ptr [ebp - 8] */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(eax + 0x396u))) & 0xffffu);  /* 0x48aded: mov cx, word ptr [eax + 0x396] */
    esp -= 4u; WR32(esp, ecx);  /* 0x48adf4: push ecx */
    ecx = 0x5c3a67u;  /* 0x48adf5: mov ecx, 0x5c3a67 */
    esp -= 4u; WR32(esp, 0x48adffu); FL41_CALL(0x4fb2e3u); esp += 4u; esp += 4u;  /* 0x48adfa: call 0x4fb2e3 */
L_48adff:
    edi = RD32(esp); esp += 4u;  /* 0x48adff: pop edi */
    esi = RD32(esp); esp += 4u;  /* 0x48ae00: pop esi */
    esp = ebp;  /* 0x48ae01: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x48ae03: pop ebp */
    esp += 4u; goto done;  /* 0x48ae04: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x48e3ca (606 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m48e3ca_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x48e3ca: push ebp */
    ebp = esp;  /* 0x48e3cb: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x18u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x48e3cd: sub esp, 0x18 */
    esp -= 4u; WR32(esp, esi);  /* 0x48e3d0: push esi */
    esp -= 4u; WR32(esp, edi);  /* 0x48e3d1: push edi */
    WR32((uint32_t)(ebp + 0xffffffe8u), ecx);  /* 0x48e3d2: mov dword ptr [ebp - 0x18], ecx */
    eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x48e3d5: mov eax, dword ptr [ebp + 0xc] */
    ecx = RD32((uint32_t)(eax));  /* 0x48e3d8: mov ecx, dword ptr [eax] */
    WR32((uint32_t)(ebp + 0xfffffff4u), ecx);  /* 0x48e3da: mov dword ptr [ebp - 0xc], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x48e3dd: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0xb0u)))) & 0xffffffffu;  /* 0x48e3e0: movsx eax, word ptr [edx + 0xb0] */
    ecx = 0x1eu;  /* 0x48e3e7: mov ecx, 0x1e */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x48e3ec: sub ecx, eax */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0xd0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x48e3ee: imul ecx, ecx, 0xd0 */
    edx = 0x1912u;  /* 0x48e3f4: mov edx, 0x1912 */
    { uint32_t a_ = edx, b_ = ecx, r_; FL41_SUB(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x48e3f9: sub edx, ecx */
    WR16((uint32_t)(ebp + 0xfffffff0u), (edx & 0xffffu));  /* 0x48e3fb: mov word ptr [ebp - 0x10], dx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff0u)))) & 0xffffffffu;  /* 0x48e3ff: movsx eax, word ptr [ebp - 0x10] */
    esp -= 4u; WR32(esp, eax);  /* 0x48e403: push eax */
    esp -= 4u; WR32(esp, 0x48e409u); FL41_CALL(0x51dc43u); esp += 4u;  /* 0x48e404: call 0x51dc43 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x48e409: add esp, 4 */
    WR32((uint32_t)(ebp + 0xffffffecu), eax);  /* 0x48e40c: mov dword ptr [ebp - 0x14], eax */
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x48e40f: mov ecx, dword ptr [ebp + 8] */
    edx = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x48e412: mov edx, dword ptr [ebp - 0x14] */
    WR32((uint32_t)(ecx), edx);  /* 0x48e415: mov dword ptr [ecx], edx */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xffffffecu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x48e417: cmp dword ptr [ebp - 0x14], 0 */
    if (!zf) goto L_48e45c;  /* 0x48e41b: jne 0x48e45c */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x5c39e3u)))) & 0xffffffffu;  /* 0x48e41d: movsx eax, word ptr [0x5c39e3] */
    esp -= 4u; WR32(esp, eax);  /* 0x48e424: push eax */
    ecx = RD32((uint32_t)(0x5bb57bu));  /* 0x48e425: mov ecx, dword ptr [0x5bb57b] */
    esp -= 4u; WR32(esp, ecx);  /* 0x48e42b: push ecx */
    esp -= 4u; WR32(esp, 0x54e924u);  /* 0x48e42c: push 0x54e924 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x48e431: push 0x63888b */
    esp -= 4u; WR32(esp, 0x48e43bu); FL41_CALL(0x50ca3eu); esp += 4u;  /* 0x48e436: call 0x50ca3e */
    { uint32_t a_ = esp, b_ = 0x10u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x48e43b: add esp, 0x10 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x48e43e: push 0x63888b */
    esp -= 4u; WR32(esp, 0x54e950u);  /* 0x48e443: push 0x54e950 */
    ecx = 0x583979u;  /* 0x48e448: mov ecx, 0x583979 */
    esp -= 4u; WR32(esp, 0x48e452u); FL41_CALL(0x42639du); esp += 8u; esp += 4u;  /* 0x48e44d: call 0x42639d */
    ecx = 0x5cf659u;  /* 0x48e452: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x48e45cu); FL41_CALL(0x4c97b4u); esp += 4u;  /* 0x48e457: call 0x4c97b4 */
L_48e45c:
    WR16((uint32_t)(ebp + 0xfffffff8u), 0x0u);  /* 0x48e45c: mov word ptr [ebp - 8], 0 */
    goto L_48e470;  /* 0x48e462: jmp 0x48e470 */
L_48e464:
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffff8u))) & 0xffffu);  /* 0x48e464: mov dx, word ptr [ebp - 8] */
    { uint32_t a_ = (edx & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); edx = (edx & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x48e468: add dx, 1 */
    WR16((uint32_t)(ebp + 0xfffffff8u), (edx & 0xffffu));  /* 0x48e46c: mov word ptr [ebp - 8], dx */
L_48e470:
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x48e470: movsx eax, word ptr [ebp - 8] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x48e474: mov ecx, dword ptr [ebp - 0xc] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0xb0u)))) & 0xffffffffu;  /* 0x48e477: movsx edx, word ptr [ecx + 0xb0] */
    { uint32_t a_ = eax, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x48e47e: cmp eax, edx */
    if ((sf == of)) goto L_48e5cc;  /* 0x48e480: jge 0x48e5cc */
    edi = 0x63a8b0u;  /* 0x48e486: mov edi, 0x63a8b0 */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x48e48b: movsx eax, word ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0xd0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x48e48f: imul eax, eax, 0xd0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x48e495: mov ecx, dword ptr [ebp - 0xc] */
    esi = (uint32_t)(ecx + eax + 0x123u);  /* 0x48e498: lea esi, [ecx + eax + 0x123] */
    ecx = 0x1u;  /* 0x48e49f: mov ecx, 1 */
    { uint32_t a_ = edx, b_ = edx, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); edx = r_; }  /* 0x48e4a4: xor edx, edx */
    /* 0x48e4a6: repe cmpsb byte ptr [esi], byte ptr es:[edi] */
    while (ecx != 0u) {
    { uint32_t a_ = RD8(esi), b_ = RD8(edi), r_;
    FL41_SUB(a_, b_, 0u, r_, 8); }
    esi += 1u; edi += 1u;
    ecx -= 1u;
    if (!zf) break;
    }
    if (!zf) goto L_48e526;  /* 0x48e4a8: jne 0x48e526 */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x48e4aa: movsx eax, word ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0xd0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x48e4ae: imul eax, eax, 0xd0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x48e4b4: mov ecx, dword ptr [ebp - 0xc] */
    edx = (uint32_t)(ecx + eax + 0x100u);  /* 0x48e4b7: lea edx, [ecx + eax + 0x100] */
    esp -= 4u; WR32(esp, edx);  /* 0x48e4be: push edx */
    ecx = 0x619a6bu;  /* 0x48e4bf: mov ecx, 0x619a6b */
    esp -= 4u; WR32(esp, 0x48e4c9u); FL41_CALL(0x423259u); esp += 4u; esp += 4u;  /* 0x48e4c4: call 0x423259 */
    WR32((uint32_t)(ebp + 0xfffffffcu), eax);  /* 0x48e4c9: mov dword ptr [ebp - 4], eax */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffffcu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x48e4cc: cmp dword ptr [ebp - 4], 0 */
    if (zf) goto L_48e526;  /* 0x48e4d0: je 0x48e526 */
    edi = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x48e4d2: mov edi, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0xffffffffu, r_; r_ = a_ | b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x48e4d5: or ecx, 0xffffffff */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x48e4d8: xor eax, eax */
    /* 0x48e4da: repne scasb al, byte ptr es:[edi] */
    while (ecx != 0u) {
    { uint32_t a_ = eax & 0xffu, b_ = RD8(edi), r_;
    FL41_SUB(a_, b_, 0u, r_, 8); }
    edi += 1u;
    ecx -= 1u;
    if (zf) break;
    }
    { uint32_t a_ = ecx; ecx = (~a_) & 0xffffffffu; }  /* 0x48e4dc: not ecx */
    esi = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x48e4de: mov esi, dword ptr [ebp - 4] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x48e4e1: movsx eax, word ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0xd0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x48e4e5: imul eax, eax, 0xd0 */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x48e4eb: mov edx, dword ptr [ebp - 0xc] */
    edi = (uint32_t)(edx + eax + 0x123u);  /* 0x48e4ee: lea edi, [edx + eax + 0x123] */
    eax = ecx;  /* 0x48e4f5: mov eax, ecx */
    { uint32_t a_ = ecx, n_ = 0x2u, r_; if (n_ != 0u) { FL41_SHR(r_, a_, n_, 32); ecx = r_; } }  /* 0x48e4f7: shr ecx, 2 */
    /* 0x48e4fa: rep movsd dword ptr es:[edi], dword ptr [esi] */
    while (ecx != 0u) {
    WR32(edi, RD32(esi));
    esi += 4u; edi += 4u;
    ecx -= 1u;
    }
    ecx = eax;  /* 0x48e4fc: mov ecx, eax */
    { uint32_t a_ = ecx, b_ = 0x3u, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x48e4fe: and ecx, 3 */
    /* 0x48e501: rep movsb byte ptr es:[edi], byte ptr [esi] */
    while (ecx != 0u) {
    WR8(edi, RD8(esi));
    esi += 1u; edi += 1u;
    ecx -= 1u;
    }
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x48e503: movsx ecx, word ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0xd0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x48e507: imul ecx, ecx, 0xd0 */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x48e50d: mov edx, dword ptr [ebp - 0xc] */
    edi = (uint32_t)(edx + ecx + 0x123u);  /* 0x48e510: lea edi, [edx + ecx + 0x123] */
    { uint32_t a_ = ecx, b_ = 0xffffffffu, r_; r_ = a_ | b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x48e517: or ecx, 0xffffffff */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x48e51a: xor eax, eax */
    /* 0x48e51c: repne scasb al, byte ptr es:[edi] */
    while (ecx != 0u) {
    { uint32_t a_ = eax & 0xffu, b_ = RD8(edi), r_;
    FL41_SUB(a_, b_, 0u, r_, 8); }
    edi += 1u;
    ecx -= 1u;
    if (zf) break;
    }
    eax = RD32((uint32_t)(0x54e96cu));  /* 0x48e51e: mov eax, dword ptr [0x54e96c] */
    WR32((uint32_t)(edi + 0xffffffffu), eax);  /* 0x48e523: mov dword ptr [edi - 1], eax */
L_48e526:
    edi = 0x63a8b4u;  /* 0x48e526: mov edi, 0x63a8b4 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x48e52b: movsx ecx, word ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0xd0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x48e52f: imul ecx, ecx, 0xd0 */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x48e535: mov edx, dword ptr [ebp - 0xc] */
    esi = (uint32_t)(edx + ecx + 0x164u);  /* 0x48e538: lea esi, [edx + ecx + 0x164] */
    ecx = 0x1u;  /* 0x48e53f: mov ecx, 1 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x48e544: xor eax, eax */
    /* 0x48e546: repe cmpsb byte ptr [esi], byte ptr es:[edi] */
    while (ecx != 0u) {
    { uint32_t a_ = RD8(esi), b_ = RD8(edi), r_;
    FL41_SUB(a_, b_, 0u, r_, 8); }
    esi += 1u; edi += 1u;
    ecx -= 1u;
    if (!zf) break;
    }
    if (!zf) goto L_48e5c7;  /* 0x48e548: jne 0x48e5c7 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x48e54a: movsx ecx, word ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0xd0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x48e54e: imul ecx, ecx, 0xd0 */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x48e554: mov edx, dword ptr [ebp - 0xc] */
    eax = (uint32_t)(edx + ecx + 0x141u);  /* 0x48e557: lea eax, [edx + ecx + 0x141] */
    esp -= 4u; WR32(esp, eax);  /* 0x48e55e: push eax */
    ecx = 0x619a6bu;  /* 0x48e55f: mov ecx, 0x619a6b */
    esp -= 4u; WR32(esp, 0x48e569u); FL41_CALL(0x423259u); esp += 4u; esp += 4u;  /* 0x48e564: call 0x423259 */
    WR32((uint32_t)(ebp + 0xfffffffcu), eax);  /* 0x48e569: mov dword ptr [ebp - 4], eax */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffffcu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x48e56c: cmp dword ptr [ebp - 4], 0 */
    if (zf) goto L_48e5c7;  /* 0x48e570: je 0x48e5c7 */
    edi = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x48e572: mov edi, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0xffffffffu, r_; r_ = a_ | b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x48e575: or ecx, 0xffffffff */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x48e578: xor eax, eax */
    /* 0x48e57a: repne scasb al, byte ptr es:[edi] */
    while (ecx != 0u) {
    { uint32_t a_ = eax & 0xffu, b_ = RD8(edi), r_;
    FL41_SUB(a_, b_, 0u, r_, 8); }
    edi += 1u;
    ecx -= 1u;
    if (zf) break;
    }
    { uint32_t a_ = ecx; ecx = (~a_) & 0xffffffffu; }  /* 0x48e57c: not ecx */
    esi = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x48e57e: mov esi, dword ptr [ebp - 4] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x48e581: movsx edx, word ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0xd0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x48e585: imul edx, edx, 0xd0 */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x48e58b: mov eax, dword ptr [ebp - 0xc] */
    edi = (uint32_t)(eax + edx + 0x164u);  /* 0x48e58e: lea edi, [eax + edx + 0x164] */
    edx = ecx;  /* 0x48e595: mov edx, ecx */
    { uint32_t a_ = ecx, n_ = 0x2u, r_; if (n_ != 0u) { FL41_SHR(r_, a_, n_, 32); ecx = r_; } }  /* 0x48e597: shr ecx, 2 */
    /* 0x48e59a: rep movsd dword ptr es:[edi], dword ptr [esi] */
    while (ecx != 0u) {
    WR32(edi, RD32(esi));
    esi += 4u; edi += 4u;
    ecx -= 1u;
    }
    ecx = edx;  /* 0x48e59c: mov ecx, edx */
    { uint32_t a_ = ecx, b_ = 0x3u, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x48e59e: and ecx, 3 */
    /* 0x48e5a1: rep movsb byte ptr es:[edi], byte ptr [esi] */
    while (ecx != 0u) {
    WR8(edi, RD8(esi));
    esi += 1u; edi += 1u;
    ecx -= 1u;
    }
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x48e5a3: movsx eax, word ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0xd0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x48e5a7: imul eax, eax, 0xd0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x48e5ad: mov ecx, dword ptr [ebp - 0xc] */
    edi = (uint32_t)(ecx + eax + 0x164u);  /* 0x48e5b0: lea edi, [ecx + eax + 0x164] */
    { uint32_t a_ = ecx, b_ = 0xffffffffu, r_; r_ = a_ | b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x48e5b7: or ecx, 0xffffffff */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x48e5ba: xor eax, eax */
    /* 0x48e5bc: repne scasb al, byte ptr es:[edi] */
    while (ecx != 0u) {
    { uint32_t a_ = eax & 0xffu, b_ = RD8(edi), r_;
    FL41_SUB(a_, b_, 0u, r_, 8); }
    edi += 1u;
    ecx -= 1u;
    if (zf) break;
    }
    edx = RD32((uint32_t)(0x54e970u));  /* 0x48e5be: mov edx, dword ptr [0x54e970] */
    WR32((uint32_t)(edi + 0xffffffffu), edx);  /* 0x48e5c4: mov dword ptr [edi - 1], edx */
L_48e5c7:
    goto L_48e464;  /* 0x48e5c7: jmp 0x48e464 */
L_48e5cc:
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff0u)))) & 0xffffffffu;  /* 0x48e5cc: movsx ecx, word ptr [ebp - 0x10] */
    eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x48e5d0: mov eax, dword ptr [ebp + 0xc] */
    esi = RD32((uint32_t)(eax));  /* 0x48e5d3: mov esi, dword ptr [eax] */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x48e5d5: mov edx, dword ptr [ebp + 8] */
    edi = RD32((uint32_t)(edx));  /* 0x48e5d8: mov edi, dword ptr [edx] */
    eax = ecx;  /* 0x48e5da: mov eax, ecx */
    { uint32_t a_ = ecx, n_ = 0x2u, r_; if (n_ != 0u) { FL41_SHR(r_, a_, n_, 32); ecx = r_; } }  /* 0x48e5dc: shr ecx, 2 */
    /* 0x48e5df: rep movsd dword ptr es:[edi], dword ptr [esi] */
    while (ecx != 0u) {
    WR32(edi, RD32(esi));
    esi += 4u; edi += 4u;
    ecx -= 1u;
    }
    ecx = eax;  /* 0x48e5e1: mov ecx, eax */
    { uint32_t a_ = ecx, b_ = 0x3u, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x48e5e3: and ecx, 3 */
    /* 0x48e5e6: rep movsb byte ptr es:[edi], byte ptr [esi] */
    while (ecx != 0u) {
    WR8(edi, RD8(esi));
    esi += 1u; edi += 1u;
    ecx -= 1u;
    }
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff0u)))) & 0xffffffffu;  /* 0x48e5e8: movsx ecx, word ptr [ebp - 0x10] */
    edx = RD32((uint32_t)(ebp + 0x10u));  /* 0x48e5ec: mov edx, dword ptr [ebp + 0x10] */
    eax = RD32((uint32_t)(edx));  /* 0x48e5ef: mov eax, dword ptr [edx] */
    { uint32_t a_ = eax, b_ = ecx, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x48e5f1: add eax, ecx */
    ecx = RD32((uint32_t)(ebp + 0x10u));  /* 0x48e5f3: mov ecx, dword ptr [ebp + 0x10] */
    WR32((uint32_t)(ecx), eax);  /* 0x48e5f6: mov dword ptr [ecx], eax */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff0u)))) & 0xffffffffu;  /* 0x48e5f8: movsx edx, word ptr [ebp - 0x10] */
    eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x48e5fc: mov eax, dword ptr [ebp + 0xc] */
    ecx = RD32((uint32_t)(eax));  /* 0x48e5ff: mov ecx, dword ptr [eax] */
    { uint32_t a_ = ecx, b_ = edx, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x48e601: add ecx, edx */
    edx = RD32((uint32_t)(ebp + 0xcu));  /* 0x48e603: mov edx, dword ptr [ebp + 0xc] */
    WR32((uint32_t)(edx), ecx);  /* 0x48e606: mov dword ptr [edx], ecx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x63a4cdu)))) & 0xffffffffu;  /* 0x48e608: movsx eax, word ptr [0x63a4cd] */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x48e60f: test eax, eax */
    if (zf) goto L_48e620;  /* 0x48e611: je 0x48e620 */
    esp -= 4u; WR32(esp, 0x54e974u);  /* 0x48e613: push 0x54e974 */
    esp -= 4u; WR32(esp, 0x48e61du); FL41_CALL(0x44a2b7u); esp += 4u;  /* 0x48e618: call 0x44a2b7 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x48e61d: add esp, 4 */
L_48e620:
    edi = RD32(esp); esp += 4u;  /* 0x48e620: pop edi */
    esi = RD32(esp); esp += 4u;  /* 0x48e621: pop esi */
    esp = ebp;  /* 0x48e622: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x48e624: pop ebp */
    esp += 16u; goto done;  /* 0x48e625: ret 0xc */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x49027c (464 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m49027c_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x49027c: push ebp */
    ebp = esp;  /* 0x49027d: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x28u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x49027f: sub esp, 0x28 */
    esp -= 4u; WR32(esp, esi);  /* 0x490282: push esi */
    esp -= 4u; WR32(esp, edi);  /* 0x490283: push edi */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x624de7u)))) & 0xffffffffu;  /* 0x490284: movsx eax, word ptr [0x624de7] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x49028b: imul eax, eax, 0x8d */
    ecx = RD32((uint32_t)(eax + 0x5bb5e5u));  /* 0x490291: mov ecx, dword ptr [eax + 0x5bb5e5] */
    WR32((uint32_t)(ebp + 0xfffffff8u), ecx);  /* 0x490297: mov dword ptr [ebp - 8], ecx */
    WR16((uint32_t)(ebp + 0xfffffffcu), 0x0u);  /* 0x49029a: mov word ptr [ebp - 4], 0 */
    goto L_4902ae;  /* 0x4902a0: jmp 0x4902ae */
L_4902a2:
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffffcu))) & 0xffffu);  /* 0x4902a2: mov dx, word ptr [ebp - 4] */
    { uint32_t a_ = (edx & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); edx = (edx & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4902a6: add dx, 1 */
    WR16((uint32_t)(ebp + 0xfffffffcu), (edx & 0xffffu));  /* 0x4902aa: mov word ptr [ebp - 4], dx */
L_4902ae:
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4902ae: movsx eax, word ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4902b2: mov ecx, dword ptr [ebp - 8] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0xb0u)))) & 0xffffffffu;  /* 0x4902b5: movsx edx, word ptr [ecx + 0xb0] */
    { uint32_t a_ = eax, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4902bc: cmp eax, edx */
    if ((sf == of)) goto L_490446;  /* 0x4902be: jge 0x490446 */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4902c4: movsx eax, word ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0xd0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4902c8: imul eax, eax, 0xd0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4902ce: mov ecx, dword ptr [ebp - 8] */
    edx = RD32((uint32_t)(ecx + eax + 0xb6u));  /* 0x4902d1: mov edx, dword ptr [ecx + eax + 0xb6] */
    WR32((uint32_t)(ebp + 0xffffffecu), edx);  /* 0x4902d8: mov dword ptr [ebp - 0x14], edx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4902db: movsx eax, word ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0xd0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4902df: imul eax, eax, 0xd0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4902e5: mov ecx, dword ptr [ebp - 8] */
    edx = RD32((uint32_t)(ecx + eax + 0xbeu));  /* 0x4902e8: mov edx, dword ptr [ecx + eax + 0xbe] */
    WR32((uint32_t)(ebp + 0xfffffff4u), edx);  /* 0x4902ef: mov dword ptr [ebp - 0xc], edx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4902f2: movsx eax, word ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0xd0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4902f6: imul eax, eax, 0xd0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4902fc: mov ecx, dword ptr [ebp - 8] */
    edx = RD32((uint32_t)(ecx + eax + 0xb2u));  /* 0x4902ff: mov edx, dword ptr [ecx + eax + 0xb2] */
    WR32((uint32_t)(ebp + 0xffffffe8u), edx);  /* 0x490306: mov dword ptr [ebp - 0x18], edx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x490309: movsx eax, word ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0xd0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x49030d: imul eax, eax, 0xd0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490313: mov ecx, dword ptr [ebp - 8] */
    edx = RD32((uint32_t)(ecx + eax + 0xbau));  /* 0x490316: mov edx, dword ptr [ecx + eax + 0xba] */
    { uint32_t a_ = edx, b_ = 0x8u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x49031d: add edx, 8 */
    WR32((uint32_t)(ebp + 0xfffffff0u), edx);  /* 0x490320: mov dword ptr [ebp - 0x10], edx */
    eax = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x490323: mov eax, dword ptr [ebp - 0x14] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x490326: add eax, dword ptr [0x58318a] */
    WR32((uint32_t)(ebp + 0xffffffdcu), eax);  /* 0x49032c: mov dword ptr [ebp - 0x24], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x49032f: mov ecx, dword ptr [ebp - 0xc] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x490332: add ecx, dword ptr [0x58318a] */
    WR32((uint32_t)(ebp + 0xffffffe4u), ecx);  /* 0x490338: mov dword ptr [ebp - 0x1c], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x49033b: mov edx, dword ptr [ebp - 0x18] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x49033e: add edx, dword ptr [0x583186] */
    WR32((uint32_t)(ebp + 0xffffffd8u), edx);  /* 0x490344: mov dword ptr [ebp - 0x28], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x490347: mov eax, dword ptr [ebp - 0x10] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x49034a: add eax, dword ptr [0x583186] */
    WR32((uint32_t)(ebp + 0xffffffe0u), eax);  /* 0x490350: mov dword ptr [ebp - 0x20], eax */
    esp -= 4u; WR32(esp, 0x54ea24u);  /* 0x490353: push 0x54ea24 */
    ecx = (uint32_t)(ebp + 0xffffffd8u);  /* 0x490358: lea ecx, [ebp - 0x28] */
    esp -= 4u; WR32(esp, ecx);  /* 0x49035b: push ecx */
    edx = (uint32_t)(ebp + 0xffffffe8u);  /* 0x49035c: lea edx, [ebp - 0x18] */
    esp -= 4u; WR32(esp, edx);  /* 0x49035f: push edx */
    eax = RD32((uint32_t)(0x5cf665u));  /* 0x490360: mov eax, dword ptr [0x5cf665] */
    esp -= 4u; WR32(esp, eax);  /* 0x490365: push eax */
    ecx = RD32((uint32_t)(0x5d15e3u));  /* 0x490366: mov ecx, dword ptr [0x5d15e3] */
    esp -= 4u; WR32(esp, ecx);  /* 0x49036c: push ecx */
    ecx = 0x5cf659u;  /* 0x49036d: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x490377u); FL41_CALL(0x4c5377u); esp += 20u; esp += 4u;  /* 0x490372: call 0x4c5377 */
    esp -= 4u; WR32(esp, 0x54ea54u);  /* 0x490377: push 0x54ea54 */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x49037c: movsx edx, word ptr [ebp - 4] */
    { uint32_t a_ = edx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); edx = r_; } }  /* 0x490380: shl edx, 4 */
    { uint32_t a_ = edx, b_ = 0x624de9u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x490383: add edx, 0x624de9 */
    esp -= 4u; WR32(esp, edx);  /* 0x490389: push edx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x49038a: movsx eax, word ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0xd0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x49038e: imul eax, eax, 0xd0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490394: mov ecx, dword ptr [ebp - 8] */
    edx = (uint32_t)(ecx + eax + 0xb2u);  /* 0x490397: lea edx, [ecx + eax + 0xb2] */
    esp -= 4u; WR32(esp, edx);  /* 0x49039e: push edx */
    eax = RD32((uint32_t)(0x5cf665u));  /* 0x49039f: mov eax, dword ptr [0x5cf665] */
    esp -= 4u; WR32(esp, eax);  /* 0x4903a4: push eax */
    ecx = RD32((uint32_t)(0x5d15e3u));  /* 0x4903a5: mov ecx, dword ptr [0x5d15e3] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4903ab: push ecx */
    ecx = 0x5cf659u;  /* 0x4903ac: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4903b6u); FL41_CALL(0x4c5377u); esp += 20u; esp += 4u;  /* 0x4903b1: call 0x4c5377 */
    edi = 0x63a8bcu;  /* 0x4903b6: mov edi, 0x63a8bc */
    esi = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4903bb: movsx esi, word ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(esi) * (int32_t)(0x11u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); esi = r_; }  /* 0x4903bf: imul esi, esi, 0x11 */
    { uint32_t a_ = esi, b_ = 0x624fc9u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esi = r_; }  /* 0x4903c2: add esi, 0x624fc9 */
    ecx = 0x1u;  /* 0x4903c8: mov ecx, 1 */
    { uint32_t a_ = edx, b_ = edx, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); edx = r_; }  /* 0x4903cd: xor edx, edx */
    /* 0x4903cf: repe cmpsb byte ptr [esi], byte ptr es:[edi] */
    while (ecx != 0u) {
    { uint32_t a_ = RD8(esi), b_ = RD8(edi), r_;
    FL41_SUB(a_, b_, 0u, r_, 8); }
    esi += 1u; edi += 1u;
    ecx -= 1u;
    if (!zf) break;
    }
    if (zf) goto L_490441;  /* 0x4903d1: je 0x490441 */
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4903d3: push 0 */
    eax = RD32((uint32_t)(0x5cf665u));  /* 0x4903d5: mov eax, dword ptr [0x5cf665] */
    esp -= 4u; WR32(esp, eax);  /* 0x4903da: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4903db: mov ecx, dword ptr [ebp - 8] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx)))) & 0xffffffffu;  /* 0x4903de: movsx edx, word ptr [ecx] */
    eax = RD32((uint32_t)(edx * 4u + 0x5d032fu));  /* 0x4903e1: mov eax, dword ptr [edx*4 + 0x5d032f] */
    esp -= 4u; WR32(esp, eax);  /* 0x4903e8: push eax */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4903e9: movsx ecx, word ptr [ebp - 4] */
    { uint32_t a_ = ecx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); ecx = r_; } }  /* 0x4903ed: shl ecx, 4 */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ecx + 0x624df5u))) & 0xffffu);  /* 0x4903f0: mov dx, word ptr [ecx + 0x624df5] */
    esp -= 4u; WR32(esp, edx);  /* 0x4903f7: push edx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4903f8: movsx eax, word ptr [ebp - 4] */
    { uint32_t a_ = eax, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); eax = r_; } }  /* 0x4903fc: shl eax, 4 */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(eax + 0x624de9u))) & 0xffffu);  /* 0x4903ff: mov cx, word ptr [eax + 0x624de9] */
    esp -= 4u; WR32(esp, ecx);  /* 0x490406: push ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490407: mov edx, dword ptr [ebp - 8] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx)))) & 0xffffffffu;  /* 0x49040a: movsx eax, word ptr [edx] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x1d0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x49040d: imul eax, eax, 0x1d0 */
    { uint32_t a_ = eax, b_ = 0x5adb3au, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x490413: add eax, 0x5adb3a */
    esp -= 4u; WR32(esp, eax);  /* 0x490418: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490419: mov ecx, dword ptr [ebp - 8] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx)))) & 0xffffffffu;  /* 0x49041c: movsx edx, word ptr [ecx] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x7f3u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x49041f: imul edx, edx, 0x7f3 */
    { uint32_t a_ = edx, b_ = 0x5a4c24u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x490425: add edx, 0x5a4c24 */
    esp -= 4u; WR32(esp, edx);  /* 0x49042b: push edx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x49042c: movsx eax, word ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x11u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x490430: imul eax, eax, 0x11 */
    { uint32_t a_ = eax, b_ = 0x624fc9u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x490433: add eax, 0x624fc9 */
    esp -= 4u; WR32(esp, eax);  /* 0x490438: push eax */
    esp -= 4u; WR32(esp, 0x49043eu); FL41_CALL(0x4d2c20u); esp += 4u;  /* 0x490439: call 0x4d2c20 */
    { uint32_t a_ = esp, b_ = 0x20u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x49043e: add esp, 0x20 */
L_490441:
    goto L_4902a2;  /* 0x490441: jmp 0x4902a2 */
L_490446:
    edi = RD32(esp); esp += 4u;  /* 0x490446: pop edi */
    esi = RD32(esp); esp += 4u;  /* 0x490447: pop esi */
    esp = ebp;  /* 0x490448: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x49044a: pop ebp */
    esp += 4u; goto done;  /* 0x49044b: ret  */
done:
    FL41_EPILOGUE
}

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

/* GAME.EXE 0x494f1f (1559 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m494f1f_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x494f1f: push ebp */
    ebp = esp;  /* 0x494f20: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x24u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x494f22: sub esp, 0x24 */
    esp -= 4u; WR32(esp, esi);  /* 0x494f25: push esi */
    esp -= 4u; WR32(esp, edi);  /* 0x494f26: push edi */
    WR32((uint32_t)(ebp + 0xffffffdcu), ecx);  /* 0x494f27: mov dword ptr [ebp - 0x24], ecx */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494f2a: mov eax, dword ptr [ebp - 0x24] */
    WR32((uint32_t)(eax + 0x1f6fu), 0x0u);  /* 0x494f2d: mov dword ptr [eax + 0x1f6f], 0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494f37: mov ecx, dword ptr [ebp - 0x24] */
    WR32((uint32_t)(ecx + 0x1f73u), 0x0u);  /* 0x494f3a: mov dword ptr [ecx + 0x1f73], 0 */
    WR8((uint32_t)(0x58322eu), 0x0u);  /* 0x494f44: mov byte ptr [0x58322e], 0 */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494f4b: mov edx, dword ptr [ebp - 0x24] */
    { uint32_t a_ = RD32((uint32_t)(edx + 0x1f7bu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x494f4e: cmp dword ptr [edx + 0x1f7b], 0 */
    if (zf) goto L_49505e;  /* 0x494f55: je 0x49505e */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494f5b: mov eax, dword ptr [ebp - 0x24] */
    WR32((uint32_t)(eax + 0x1f7bu), 0x0u);  /* 0x494f5e: mov dword ptr [eax + 0x1f7b], 0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494f68: mov ecx, dword ptr [ebp - 0x24] */
    { uint32_t a_ = ecx, b_ = 0x2023u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x494f6b: add ecx, 0x2023 */
    esp -= 4u; WR32(esp, ecx);  /* 0x494f71: push ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494f72: mov edx, dword ptr [ebp - 0x24] */
    { uint32_t a_ = edx, b_ = 0x82u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x494f75: add edx, 0x82 */
    esp -= 4u; WR32(esp, edx);  /* 0x494f7b: push edx */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494f7c: mov ecx, dword ptr [ebp - 0x24] */
    esp -= 4u; WR32(esp, 0x494f84u); FL41_CALL(0x495536u); esp += 8u; esp += 4u;  /* 0x494f7f: call 0x495536 */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494f84: mov eax, dword ptr [ebp - 0x24] */
    { uint32_t a_ = eax, b_ = 0x2025u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x494f87: add eax, 0x2025 */
    esp -= 4u; WR32(esp, eax);  /* 0x494f8c: push eax */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494f8d: mov ecx, dword ptr [ebp - 0x24] */
    { uint32_t a_ = ecx, b_ = 0x88u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x494f90: add ecx, 0x88 */
    esp -= 4u; WR32(esp, ecx);  /* 0x494f96: push ecx */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494f97: mov ecx, dword ptr [ebp - 0x24] */
    esp -= 4u; WR32(esp, 0x494f9fu); FL41_CALL(0x495536u); esp += 8u; esp += 4u;  /* 0x494f9a: call 0x495536 */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494f9f: mov edx, dword ptr [ebp - 0x24] */
    { uint32_t a_ = edx, b_ = 0x2027u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x494fa2: add edx, 0x2027 */
    esp -= 4u; WR32(esp, edx);  /* 0x494fa8: push edx */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494fa9: mov eax, dword ptr [ebp - 0x24] */
    { uint32_t a_ = eax, b_ = 0x8bu, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x494fac: add eax, 0x8b */
    esp -= 4u; WR32(esp, eax);  /* 0x494fb1: push eax */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494fb2: mov ecx, dword ptr [ebp - 0x24] */
    esp -= 4u; WR32(esp, 0x494fbau); FL41_CALL(0x495536u); esp += 8u; esp += 4u;  /* 0x494fb5: call 0x495536 */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494fba: mov ecx, dword ptr [ebp - 0x24] */
    { uint32_t a_ = ecx, b_ = 0x2029u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x494fbd: add ecx, 0x2029 */
    esp -= 4u; WR32(esp, ecx);  /* 0x494fc3: push ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494fc4: mov edx, dword ptr [ebp - 0x24] */
    { uint32_t a_ = edx, b_ = 0x8eu, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x494fc7: add edx, 0x8e */
    esp -= 4u; WR32(esp, edx);  /* 0x494fcd: push edx */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494fce: mov ecx, dword ptr [ebp - 0x24] */
    esp -= 4u; WR32(esp, 0x494fd6u); FL41_CALL(0x495536u); esp += 8u; esp += 4u;  /* 0x494fd1: call 0x495536 */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494fd6: mov eax, dword ptr [ebp - 0x24] */
    { uint32_t a_ = eax, b_ = 0x202bu, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x494fd9: add eax, 0x202b */
    esp -= 4u; WR32(esp, eax);  /* 0x494fde: push eax */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494fdf: mov ecx, dword ptr [ebp - 0x24] */
    { uint32_t a_ = ecx, b_ = 0x91u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x494fe2: add ecx, 0x91 */
    esp -= 4u; WR32(esp, ecx);  /* 0x494fe8: push ecx */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494fe9: mov ecx, dword ptr [ebp - 0x24] */
    esp -= 4u; WR32(esp, 0x494ff1u); FL41_CALL(0x495536u); esp += 8u; esp += 4u;  /* 0x494fec: call 0x495536 */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494ff1: mov edx, dword ptr [ebp - 0x24] */
    { uint32_t a_ = edx, b_ = 0x202du, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x494ff4: add edx, 0x202d */
    esp -= 4u; WR32(esp, edx);  /* 0x494ffa: push edx */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x494ffb: mov eax, dword ptr [ebp - 0x24] */
    { uint32_t a_ = eax, b_ = 0x94u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x494ffe: add eax, 0x94 */
    esp -= 4u; WR32(esp, eax);  /* 0x495003: push eax */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495004: mov ecx, dword ptr [ebp - 0x24] */
    esp -= 4u; WR32(esp, 0x49500cu); FL41_CALL(0x495536u); esp += 8u; esp += 4u;  /* 0x495007: call 0x495536 */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x49500c: mov ecx, dword ptr [ebp - 0x24] */
    { uint32_t a_ = ecx, b_ = 0x202fu, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x49500f: add ecx, 0x202f */
    esp -= 4u; WR32(esp, ecx);  /* 0x495015: push ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495016: mov edx, dword ptr [ebp - 0x24] */
    { uint32_t a_ = edx, b_ = 0x97u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x495019: add edx, 0x97 */
    esp -= 4u; WR32(esp, edx);  /* 0x49501f: push edx */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495020: mov ecx, dword ptr [ebp - 0x24] */
    esp -= 4u; WR32(esp, 0x495028u); FL41_CALL(0x495536u); esp += 8u; esp += 4u;  /* 0x495023: call 0x495536 */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495028: mov eax, dword ptr [ebp - 0x24] */
    { uint32_t a_ = eax, b_ = 0x2031u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x49502b: add eax, 0x2031 */
    esp -= 4u; WR32(esp, eax);  /* 0x495030: push eax */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495031: mov ecx, dword ptr [ebp - 0x24] */
    { uint32_t a_ = ecx, b_ = 0x9au, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x495034: add ecx, 0x9a */
    esp -= 4u; WR32(esp, ecx);  /* 0x49503a: push ecx */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x49503b: mov ecx, dword ptr [ebp - 0x24] */
    esp -= 4u; WR32(esp, 0x495043u); FL41_CALL(0x495536u); esp += 8u; esp += 4u;  /* 0x49503e: call 0x495536 */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495043: mov edx, dword ptr [ebp - 0x24] */
    { uint32_t a_ = edx, b_ = 0x2033u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x495046: add edx, 0x2033 */
    esp -= 4u; WR32(esp, edx);  /* 0x49504c: push edx */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x49504d: mov eax, dword ptr [ebp - 0x24] */
    { uint32_t a_ = eax, b_ = 0x9du, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x495050: add eax, 0x9d */
    esp -= 4u; WR32(esp, eax);  /* 0x495055: push eax */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495056: mov ecx, dword ptr [ebp - 0x24] */
    esp -= 4u; WR32(esp, 0x49505eu); FL41_CALL(0x495536u); esp += 8u; esp += 4u;  /* 0x495059: call 0x495536 */
L_49505e:
    ecx = RD32((uint32_t)(0x635bb4u));  /* 0x49505e: mov ecx, dword ptr [0x635bb4] */
    { uint32_t a_ = ecx, n_ = 0x1u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); ecx = r_; } }  /* 0x495064: shl ecx, 1 */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495066: mov edx, dword ptr [ebp - 0x24] */
    WR32((uint32_t)(edx + 0x203du), ecx);  /* 0x495069: mov dword ptr [edx + 0x203d], ecx */
    eax = RD32((uint32_t)(0x635bb8u));  /* 0x49506f: mov eax, dword ptr [0x635bb8] */
    { uint32_t a_ = eax, n_ = 0x1u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); eax = r_; } }  /* 0x495074: shl eax, 1 */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495076: mov ecx, dword ptr [ebp - 0x24] */
    WR32((uint32_t)(ecx + 0x2041u), eax);  /* 0x495079: mov dword ptr [ecx + 0x2041], eax */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x49507f: mov edx, dword ptr [ebp - 0x24] */
    WR32((uint32_t)(edx + 0x2045u), 0x2u);  /* 0x495082: mov dword ptr [edx + 0x2045], 2 */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x49508c: mov eax, dword ptr [ebp - 0x24] */
    WR32((uint32_t)(eax + 0x2049u), 0x2u);  /* 0x49508f: mov dword ptr [eax + 0x2049], 2 */
    esp -= 4u; WR32(esp, 0x54f85cu);  /* 0x495099: push 0x54f85c */
    esp -= 4u; WR32(esp, 0x8u);  /* 0x49509e: push 8 */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4950a0: mov ecx, dword ptr [ebp - 0x24] */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ecx + 0x2041u))) & 0xffffu);  /* 0x4950a3: mov dx, word ptr [ecx + 0x2041] */
    esp -= 4u; WR32(esp, edx);  /* 0x4950aa: push edx */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4950ab: mov eax, dword ptr [ebp - 0x24] */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(eax + 0x203du))) & 0xffffu);  /* 0x4950ae: mov cx, word ptr [eax + 0x203d] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4950b5: push ecx */
    ecx = 0x5cf659u;  /* 0x4950b6: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4950c0u); FL41_CALL(0x4c2a8du); esp += 16u; esp += 4u;  /* 0x4950bb: call 0x4c2a8d */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4950c0: mov edx, dword ptr [ebp - 0x24] */
    WR32((uint32_t)(edx + 0x2035u), eax);  /* 0x4950c3: mov dword ptr [edx + 0x2035], eax */
    esp -= 4u; WR32(esp, 0x54f870u);  /* 0x4950c9: push 0x54f870 */
    esp -= 4u; WR32(esp, 0x8u);  /* 0x4950ce: push 8 */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4950d0: mov eax, dword ptr [ebp - 0x24] */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(eax + 0x2049u))) & 0xffffu);  /* 0x4950d3: mov cx, word ptr [eax + 0x2049] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4950da: push ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4950db: mov edx, dword ptr [ebp - 0x24] */
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(edx + 0x2045u))) & 0xffffu);  /* 0x4950de: mov ax, word ptr [edx + 0x2045] */
    esp -= 4u; WR32(esp, eax);  /* 0x4950e5: push eax */
    ecx = 0x5cf659u;  /* 0x4950e6: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4950f0u); FL41_CALL(0x4c2a8du); esp += 16u; esp += 4u;  /* 0x4950eb: call 0x4c2a8d */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4950f0: mov ecx, dword ptr [ebp - 0x24] */
    WR32((uint32_t)(ecx + 0x2039u), eax);  /* 0x4950f3: mov dword ptr [ecx + 0x2039], eax */
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4950f9: push 0 */
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4950fb: push 0 */
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4950fd: push 0 */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4950ff: mov edx, dword ptr [ebp - 0x24] */
    eax = RD32((uint32_t)(edx + 0x2035u));  /* 0x495102: mov eax, dword ptr [edx + 0x2035] */
    esp -= 4u; WR32(esp, eax);  /* 0x495108: push eax */
    ecx = 0x5cf659u;  /* 0x495109: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x495113u); FL41_CALL(0x4c46d1u); esp += 16u; esp += 4u;  /* 0x49510e: call 0x4c46d1 */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495113: mov ecx, dword ptr [ebp - 0x24] */
    edx = (edx & 0xffffff00u) | ((RD8((uint32_t)(ecx + 0x87u))) & 0xffu);  /* 0x495116: mov dl, byte ptr [ecx + 0x87] */
    esp -= 4u; WR32(esp, edx);  /* 0x49511c: push edx */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x49511d: mov eax, dword ptr [ebp - 0x24] */
    ecx = (ecx & 0xffffff00u) | ((RD8((uint32_t)(eax + 0x86u))) & 0xffu);  /* 0x495120: mov cl, byte ptr [eax + 0x86] */
    esp -= 4u; WR32(esp, ecx);  /* 0x495126: push ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495127: mov edx, dword ptr [ebp - 0x24] */
    eax = (eax & 0xffffff00u) | ((RD8((uint32_t)(edx + 0x85u))) & 0xffu);  /* 0x49512a: mov al, byte ptr [edx + 0x85] */
    esp -= 4u; WR32(esp, eax);  /* 0x495130: push eax */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495131: mov ecx, dword ptr [ebp - 0x24] */
    edx = RD32((uint32_t)(ecx + 0x2039u));  /* 0x495134: mov edx, dword ptr [ecx + 0x2039] */
    esp -= 4u; WR32(esp, edx);  /* 0x49513a: push edx */
    ecx = 0x5cf659u;  /* 0x49513b: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x495145u); FL41_CALL(0x4c46d1u); esp += 16u; esp += 4u;  /* 0x495140: call 0x4c46d1 */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495145: mov eax, dword ptr [ebp - 0x24] */
    WR32((uint32_t)(eax + 0x2055u), 0x0u);  /* 0x495148: mov dword ptr [eax + 0x2055], 0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495152: mov ecx, dword ptr [ebp - 0x24] */
    WR32((uint32_t)(ecx + 0x2059u), 0x0u);  /* 0x495155: mov dword ptr [ecx + 0x2059], 0 */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x49515f: mov edx, dword ptr [ebp - 0x24] */
    eax = RD32((uint32_t)(edx + 0x203du));  /* 0x495162: mov eax, dword ptr [edx + 0x203d] */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x495168: sub eax, 1 */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x49516b: mov ecx, dword ptr [ebp - 0x24] */
    WR32((uint32_t)(ecx + 0x205du), eax);  /* 0x49516e: mov dword ptr [ecx + 0x205d], eax */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495174: mov edx, dword ptr [ebp - 0x24] */
    eax = RD32((uint32_t)(edx + 0x2041u));  /* 0x495177: mov eax, dword ptr [edx + 0x2041] */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x49517d: sub eax, 1 */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495180: mov ecx, dword ptr [ebp - 0x24] */
    WR32((uint32_t)(ecx + 0x2061u), eax);  /* 0x495183: mov dword ptr [ecx + 0x2061], eax */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495189: mov edx, dword ptr [ebp - 0x24] */
    WR32((uint32_t)(edx + 0x2075u), 0x0u);  /* 0x49518c: mov dword ptr [edx + 0x2075], 0 */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495196: mov eax, dword ptr [ebp - 0x24] */
    WR32((uint32_t)(eax + 0x2079u), 0x0u);  /* 0x495199: mov dword ptr [eax + 0x2079], 0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4951a3: mov ecx, dword ptr [ebp - 0x24] */
    edx = RD32((uint32_t)(ecx + 0x2045u));  /* 0x4951a6: mov edx, dword ptr [ecx + 0x2045] */
    { uint32_t a_ = edx, b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4951ac: sub edx, 1 */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4951af: mov eax, dword ptr [ebp - 0x24] */
    WR32((uint32_t)(eax + 0x207du), edx);  /* 0x4951b2: mov dword ptr [eax + 0x207d], edx */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4951b8: mov ecx, dword ptr [ebp - 0x24] */
    edx = RD32((uint32_t)(ecx + 0x2049u));  /* 0x4951bb: mov edx, dword ptr [ecx + 0x2049] */
    { uint32_t a_ = edx, b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4951c1: sub edx, 1 */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4951c4: mov eax, dword ptr [ebp - 0x24] */
    WR32((uint32_t)(eax + 0x2081u), edx);  /* 0x4951c7: mov dword ptr [eax + 0x2081], edx */
    WR32((uint32_t)(ebp + 0xffffffecu), 0x0u);  /* 0x4951cd: mov dword ptr [ebp - 0x14], 0 */
    WR32((uint32_t)(ebp + 0xfffffff0u), 0x0u);  /* 0x4951d4: mov dword ptr [ebp - 0x10], 0 */
    goto L_4951ef;  /* 0x4951db: jmp 0x4951ef */
L_4951dd:
    ecx = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x4951dd: mov ecx, dword ptr [ebp - 0x14] */
    { uint32_t a_ = ecx, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4951e0: add ecx, 1 */
    WR32((uint32_t)(ebp + 0xffffffecu), ecx);  /* 0x4951e3: mov dword ptr [ebp - 0x14], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4951e6: mov edx, dword ptr [ebp - 0x10] */
    { uint32_t a_ = edx, b_ = 0x2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4951e9: add edx, 2 */
    WR32((uint32_t)(ebp + 0xfffffff0u), edx);  /* 0x4951ec: mov dword ptr [ebp - 0x10], edx */
L_4951ef:
    eax = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x4951ef: mov eax, dword ptr [ebp - 0x14] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x635bb8u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4951f2: cmp eax, dword ptr [0x635bb8] */
    if ((sf == of)) goto L_495530;  /* 0x4951f8: jge 0x495530 */
    WR32((uint32_t)(ebp + 0xffffffe0u), 0x0u);  /* 0x4951fe: mov dword ptr [ebp - 0x20], 0 */
    WR32((uint32_t)(ebp + 0xffffffe4u), 0x0u);  /* 0x495205: mov dword ptr [ebp - 0x1c], 0 */
    goto L_495220;  /* 0x49520c: jmp 0x495220 */
L_49520e:
    ecx = RD32((uint32_t)(ebp + 0xffffffe0u));  /* 0x49520e: mov ecx, dword ptr [ebp - 0x20] */
    { uint32_t a_ = ecx, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x495211: add ecx, 1 */
    WR32((uint32_t)(ebp + 0xffffffe0u), ecx);  /* 0x495214: mov dword ptr [ebp - 0x20], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x495217: mov edx, dword ptr [ebp - 0x1c] */
    { uint32_t a_ = edx, b_ = 0x2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x49521a: add edx, 2 */
    WR32((uint32_t)(ebp + 0xffffffe4u), edx);  /* 0x49521d: mov dword ptr [ebp - 0x1c], edx */
L_495220:
    eax = RD32((uint32_t)(ebp + 0xffffffe0u));  /* 0x495220: mov eax, dword ptr [ebp - 0x20] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x635bb4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x495223: cmp eax, dword ptr [0x635bb4] */
    if ((sf == of)) goto L_4954cd;  /* 0x495229: jge 0x4954cd */
    ecx = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x49522f: mov ecx, dword ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0xa6u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x495232: imul ecx, ecx, 0xa6 */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495238: mov edx, dword ptr [ebp - 0x24] */
    eax = RD32((uint32_t)(edx + 0x1f47u));  /* 0x49523b: mov eax, dword ptr [edx + 0x1f47] */
    ecx = (uint32_t)(eax + ecx * 4u);  /* 0x495241: lea ecx, [eax + ecx*4] */
    edx = RD32((uint32_t)(ebp + 0xffffffe0u));  /* 0x495244: mov edx, dword ptr [ebp - 0x20] */
    eax = RD32((uint32_t)(ecx + edx * 4u));  /* 0x495247: mov eax, dword ptr [ecx + edx*4] */
    WR32((uint32_t)(ebp + 0xffffffe8u), eax);  /* 0x49524a: mov dword ptr [ebp - 0x18], eax */
    ecx = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x49524d: mov ecx, dword ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0xa6u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x495250: imul ecx, ecx, 0xa6 */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495256: mov edx, dword ptr [ebp - 0x24] */
    eax = RD32((uint32_t)(edx + 0x1f53u));  /* 0x495259: mov eax, dword ptr [edx + 0x1f53] */
    ecx = (uint32_t)(eax + ecx * 4u);  /* 0x49525f: lea ecx, [eax + ecx*4] */
    edx = RD32((uint32_t)(ebp + 0xffffffe0u));  /* 0x495262: mov edx, dword ptr [ebp - 0x20] */
    eax = RD32((uint32_t)(ecx + edx * 4u));  /* 0x495265: mov eax, dword ptr [ecx + edx*4] */
    WR32((uint32_t)(ebp + 0xfffffff8u), eax);  /* 0x495268: mov dword ptr [ebp - 8], eax */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x49526b: mov ecx, dword ptr [ebp - 0x24] */
    edx = RD32((uint32_t)(ecx + 0x2035u));  /* 0x49526e: mov edx, dword ptr [ecx + 0x2035] */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495274: mov eax, dword ptr [ebp - 0x24] */
    ecx = RD32((uint32_t)(eax + 0x2035u));  /* 0x495277: mov ecx, dword ptr [eax + 0x2035] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0x2fu)))) & 0xffffffffu;  /* 0x49527d: movsx eax, word ptr [ecx + 0x2f] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x495281: mov ecx, dword ptr [ebp - 0x10] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(eax); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x495284: imul ecx, eax */
    edx = RD32((uint32_t)(edx));  /* 0x495287: mov edx, dword ptr [edx] */
    { uint32_t a_ = edx, b_ = ecx, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x495289: add edx, ecx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x639895u)))) & 0xffffffffu;  /* 0x49528b: movsx eax, word ptr [0x639895] */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x495292: mov ecx, dword ptr [ebp - 0x1c] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(eax); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x495295: imul ecx, eax */
    { uint32_t a_ = edx, b_ = ecx, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x495298: add edx, ecx */
    WR32((uint32_t)(ebp + 0xfffffff4u), edx);  /* 0x49529a: mov dword ptr [ebp - 0xc], edx */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x49529d: mov edx, dword ptr [ebp - 0x18] */
    { uint32_t a_ = edx, b_ = 0x1000000u, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); edx = r_; }  /* 0x4952a0: and edx, 0x1000000 */
    { uint32_t a_ = edx, b_ = edx, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4952a6: test edx, edx */
    if (zf) goto L_4952d9;  /* 0x4952a8: je 0x4952d9 */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4952aa: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ebp + 0xfffffffcu), eax);  /* 0x4952ad: mov dword ptr [ebp - 4], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4952b0: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4952b3: mov edx, dword ptr [ebp - 0x24] */
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(edx + 0x2023u))) & 0xffffu);  /* 0x4952b6: mov ax, word ptr [edx + 0x2023] */
    WR16((uint32_t)(ecx), (eax & 0xffffu));  /* 0x4952bd: mov word ptr [ecx], ax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4952c0: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4952c3: add ecx, 2 */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4952c6: mov dword ptr [ebp - 4], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4952c9: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4952cc: mov eax, dword ptr [ebp - 0x24] */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(eax + 0x2023u))) & 0xffffu);  /* 0x4952cf: mov cx, word ptr [eax + 0x2023] */
    WR16((uint32_t)(edx), (ecx & 0xffffu));  /* 0x4952d6: mov word ptr [edx], cx */
L_4952d9:
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xffffffe8u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4952d9: cmp dword ptr [ebp - 0x18], 0 */
    if (zf) goto L_49531b;  /* 0x4952dd: je 0x49531b */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4952df: mov edx, dword ptr [ebp - 0x18] */
    { uint32_t a_ = edx, b_ = 0x1000000u, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); edx = r_; }  /* 0x4952e2: and edx, 0x1000000 */
    { uint32_t a_ = edx, b_ = edx, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4952e8: test edx, edx */
    if (!zf) goto L_49531b;  /* 0x4952ea: jne 0x49531b */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4952ec: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ebp + 0xfffffffcu), eax);  /* 0x4952ef: mov dword ptr [ebp - 4], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4952f2: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4952f5: mov edx, dword ptr [ebp - 0x24] */
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(edx + 0x202bu))) & 0xffffu);  /* 0x4952f8: mov ax, word ptr [edx + 0x202b] */
    WR16((uint32_t)(ecx), (eax & 0xffffu));  /* 0x4952ff: mov word ptr [ecx], ax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x495302: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x495305: add ecx, 2 */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x495308: mov dword ptr [ebp - 4], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49530b: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x49530e: mov eax, dword ptr [ebp - 0x24] */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(eax + 0x202bu))) & 0xffffu);  /* 0x495311: mov cx, word ptr [eax + 0x202b] */
    WR16((uint32_t)(edx), (ecx & 0xffffu));  /* 0x495318: mov word ptr [edx], cx */
L_49531b:
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x49531b: mov edx, dword ptr [ebp - 0x18] */
    { uint32_t a_ = edx, b_ = 0x2000000u, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); edx = r_; }  /* 0x49531e: and edx, 0x2000000 */
    { uint32_t a_ = edx, b_ = edx, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x495324: test edx, edx */
    if (!zf) goto L_495334;  /* 0x495326: jne 0x495334 */
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x495328: mov eax, dword ptr [ebp - 0x18] */
    { uint32_t a_ = eax, b_ = 0x4000000u, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x49532b: and eax, 0x4000000 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x495330: test eax, eax */
    if (zf) goto L_495363;  /* 0x495332: je 0x495363 */
L_495334:
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x495334: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x495337: mov dword ptr [ebp - 4], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49533a: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x49533d: mov eax, dword ptr [ebp - 0x24] */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(eax + 0x202du))) & 0xffffu);  /* 0x495340: mov cx, word ptr [eax + 0x202d] */
    WR16((uint32_t)(edx), (ecx & 0xffffu));  /* 0x495347: mov word ptr [edx], cx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49534a: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x49534d: add edx, 2 */
    WR32((uint32_t)(ebp + 0xfffffffcu), edx);  /* 0x495350: mov dword ptr [ebp - 4], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x495353: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495356: mov ecx, dword ptr [ebp - 0x24] */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ecx + 0x202du))) & 0xffffu);  /* 0x495359: mov dx, word ptr [ecx + 0x202d] */
    WR16((uint32_t)(eax), (edx & 0xffffu));  /* 0x495360: mov word ptr [eax], dx */
L_495363:
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x495363: mov eax, dword ptr [ebp - 0x18] */
    { uint32_t a_ = eax, b_ = 0x10000000u, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x495366: and eax, 0x10000000 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x49536b: test eax, eax */
    if (zf) goto L_49539e;  /* 0x49536d: je 0x49539e */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x49536f: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x495372: mov dword ptr [ebp - 4], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x495375: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495378: mov eax, dword ptr [ebp - 0x24] */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(eax + 0x202fu))) & 0xffffu);  /* 0x49537b: mov cx, word ptr [eax + 0x202f] */
    WR16((uint32_t)(edx), (ecx & 0xffffu));  /* 0x495382: mov word ptr [edx], cx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x495385: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x495388: add edx, 2 */
    WR32((uint32_t)(ebp + 0xfffffffcu), edx);  /* 0x49538b: mov dword ptr [ebp - 4], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49538e: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495391: mov ecx, dword ptr [ebp - 0x24] */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ecx + 0x202fu))) & 0xffffu);  /* 0x495394: mov dx, word ptr [ecx + 0x202f] */
    WR16((uint32_t)(eax), (edx & 0xffffu));  /* 0x49539b: mov word ptr [eax], dx */
L_49539e:
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x49539e: mov eax, dword ptr [ebp - 0x18] */
    { uint32_t a_ = eax, b_ = 0x20000000u, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4953a1: and eax, 0x20000000 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4953a6: test eax, eax */
    if (zf) goto L_4953d9;  /* 0x4953a8: je 0x4953d9 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4953aa: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4953ad: mov dword ptr [ebp - 4], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4953b0: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4953b3: mov eax, dword ptr [ebp - 0x24] */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(eax + 0x2031u))) & 0xffffu);  /* 0x4953b6: mov cx, word ptr [eax + 0x2031] */
    WR16((uint32_t)(edx), (ecx & 0xffffu));  /* 0x4953bd: mov word ptr [edx], cx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4953c0: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4953c3: add edx, 2 */
    WR32((uint32_t)(ebp + 0xfffffffcu), edx);  /* 0x4953c6: mov dword ptr [ebp - 4], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4953c9: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4953cc: mov ecx, dword ptr [ebp - 0x24] */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ecx + 0x2031u))) & 0xffffu);  /* 0x4953cf: mov dx, word ptr [ecx + 0x2031] */
    WR16((uint32_t)(eax), (edx & 0xffffu));  /* 0x4953d6: mov word ptr [eax], dx */
L_4953d9:
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4953d9: mov eax, dword ptr [ebp - 8] */
    { uint32_t a_ = eax, b_ = 0xffu, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4953dc: and eax, 0xff */
    { uint32_t a_ = eax, b_ = 0x2u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4953e1: cmp eax, 2 */
    if (!zf) goto L_495415;  /* 0x4953e4: jne 0x495415 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4953e6: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4953e9: mov dword ptr [ebp - 4], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4953ec: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4953ef: mov eax, dword ptr [ebp - 0x24] */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(eax + 0x2027u))) & 0xffffu);  /* 0x4953f2: mov cx, word ptr [eax + 0x2027] */
    WR16((uint32_t)(edx), (ecx & 0xffffu));  /* 0x4953f9: mov word ptr [edx], cx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4953fc: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4953ff: add edx, 2 */
    WR32((uint32_t)(ebp + 0xfffffffcu), edx);  /* 0x495402: mov dword ptr [ebp - 4], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x495405: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495408: mov ecx, dword ptr [ebp - 0x24] */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ecx + 0x2027u))) & 0xffffu);  /* 0x49540b: mov dx, word ptr [ecx + 0x2027] */
    WR16((uint32_t)(eax), (edx & 0xffffu));  /* 0x495412: mov word ptr [eax], dx */
L_495415:
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x495415: mov eax, dword ptr [ebp - 8] */
    { uint32_t a_ = eax, b_ = 0xffu, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x495418: and eax, 0xff */
    { uint32_t a_ = eax, b_ = 0x3u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x49541d: cmp eax, 3 */
    if (!zf) goto L_495451;  /* 0x495420: jne 0x495451 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x495422: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x495425: mov dword ptr [ebp - 4], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x495428: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x49542b: mov eax, dword ptr [ebp - 0x24] */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(eax + 0x2033u))) & 0xffffu);  /* 0x49542e: mov cx, word ptr [eax + 0x2033] */
    WR16((uint32_t)(edx), (ecx & 0xffffu));  /* 0x495435: mov word ptr [edx], cx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x495438: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x49543b: add edx, 2 */
    WR32((uint32_t)(ebp + 0xfffffffcu), edx);  /* 0x49543e: mov dword ptr [ebp - 4], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x495441: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495444: mov ecx, dword ptr [ebp - 0x24] */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ecx + 0x2033u))) & 0xffffu);  /* 0x495447: mov dx, word ptr [ecx + 0x2033] */
    WR16((uint32_t)(eax), (edx & 0xffffu));  /* 0x49544e: mov word ptr [eax], dx */
L_495451:
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x495451: mov eax, dword ptr [ebp - 0x18] */
    { uint32_t a_ = eax, b_ = 0x8000000u, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x495454: and eax, 0x8000000 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x495459: test eax, eax */
    if (zf) goto L_49548c;  /* 0x49545b: je 0x49548c */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x49545d: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x495460: mov dword ptr [ebp - 4], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x495463: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495466: mov eax, dword ptr [ebp - 0x24] */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(eax + 0x2025u))) & 0xffffu);  /* 0x495469: mov cx, word ptr [eax + 0x2025] */
    WR16((uint32_t)(edx), (ecx & 0xffffu));  /* 0x495470: mov word ptr [edx], cx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x495473: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x495476: add edx, 2 */
    WR32((uint32_t)(ebp + 0xfffffffcu), edx);  /* 0x495479: mov dword ptr [ebp - 4], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49547c: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x49547f: mov ecx, dword ptr [ebp - 0x24] */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ecx + 0x2025u))) & 0xffffu);  /* 0x495482: mov dx, word ptr [ecx + 0x2025] */
    WR16((uint32_t)(eax), (edx & 0xffffu));  /* 0x495489: mov word ptr [eax], dx */
L_49548c:
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x49548c: mov eax, dword ptr [ebp - 8] */
    { uint32_t a_ = eax, b_ = 0xffu, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x49548f: and eax, 0xff */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x495494: cmp eax, 1 */
    if (!zf) goto L_4954c8;  /* 0x495497: jne 0x4954c8 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x495499: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x49549c: mov dword ptr [ebp - 4], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49549f: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4954a2: mov eax, dword ptr [ebp - 0x24] */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(eax + 0x2029u))) & 0xffffu);  /* 0x4954a5: mov cx, word ptr [eax + 0x2029] */
    WR16((uint32_t)(edx), (ecx & 0xffffu));  /* 0x4954ac: mov word ptr [edx], cx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4954af: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4954b2: add edx, 2 */
    WR32((uint32_t)(ebp + 0xfffffffcu), edx);  /* 0x4954b5: mov dword ptr [ebp - 4], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4954b8: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4954bb: mov ecx, dword ptr [ebp - 0x24] */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ecx + 0x2029u))) & 0xffffu);  /* 0x4954be: mov dx, word ptr [ecx + 0x2029] */
    WR16((uint32_t)(eax), (edx & 0xffffu));  /* 0x4954c5: mov word ptr [eax], dx */
L_4954c8:
    goto L_49520e;  /* 0x4954c8: jmp 0x49520e */
L_4954cd:
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4954cd: mov eax, dword ptr [ebp - 0x24] */
    ecx = RD32((uint32_t)(eax + 0x2035u));  /* 0x4954d0: mov ecx, dword ptr [eax + 0x2035] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0x2fu)))) & 0xffffffffu;  /* 0x4954d6: movsx ecx, word ptr [ecx + 0x2f] */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4954da: mov edx, dword ptr [ebp - 0x24] */
    eax = RD32((uint32_t)(edx + 0x2035u));  /* 0x4954dd: mov eax, dword ptr [edx + 0x2035] */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4954e3: mov edx, dword ptr [ebp - 0x24] */
    edx = RD32((uint32_t)(edx + 0x2035u));  /* 0x4954e6: mov edx, dword ptr [edx + 0x2035] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x2fu)))) & 0xffffffffu;  /* 0x4954ec: movsx edx, word ptr [edx + 0x2f] */
    esi = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4954f0: mov esi, dword ptr [ebp - 0x10] */
    { int64_t w_ = (int64_t)(int32_t)(esi) * (int32_t)(edx); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); esi = r_; }  /* 0x4954f3: imul esi, edx */
    eax = RD32((uint32_t)(eax));  /* 0x4954f6: mov eax, dword ptr [eax] */
    { uint32_t a_ = esi, b_ = eax, r_; FL41_ADD(a_, b_, 0u, r_, 32); esi = r_; }  /* 0x4954f8: add esi, eax */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4954fa: mov edx, dword ptr [ebp - 0x24] */
    eax = RD32((uint32_t)(edx + 0x2035u));  /* 0x4954fd: mov eax, dword ptr [edx + 0x2035] */
    edx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x495503: mov edx, dword ptr [ebp - 0x10] */
    { uint32_t a_ = edx, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x495506: add edx, 1 */
    edi = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x495509: mov edi, dword ptr [ebp - 0x24] */
    edi = RD32((uint32_t)(edi + 0x2035u));  /* 0x49550c: mov edi, dword ptr [edi + 0x2035] */
    edi = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edi + 0x2fu)))) & 0xffffffffu;  /* 0x495512: movsx edi, word ptr [edi + 0x2f] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(edi); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x495516: imul edx, edi */
    edi = RD32((uint32_t)(eax));  /* 0x495519: mov edi, dword ptr [eax] */
    { uint32_t a_ = edi, b_ = edx, r_; FL41_ADD(a_, b_, 0u, r_, 32); edi = r_; }  /* 0x49551b: add edi, edx */
    eax = ecx;  /* 0x49551d: mov eax, ecx */
    { uint32_t a_ = ecx, n_ = 0x2u, r_; if (n_ != 0u) { FL41_SHR(r_, a_, n_, 32); ecx = r_; } }  /* 0x49551f: shr ecx, 2 */
    /* 0x495522: rep movsd dword ptr es:[edi], dword ptr [esi] */
    while (ecx != 0u) {
    WR32(edi, RD32(esi));
    esi += 4u; edi += 4u;
    ecx -= 1u;
    }
    ecx = eax;  /* 0x495524: mov ecx, eax */
    { uint32_t a_ = ecx, b_ = 0x3u, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x495526: and ecx, 3 */
    /* 0x495529: rep movsb byte ptr es:[edi], byte ptr [esi] */
    while (ecx != 0u) {
    WR8(edi, RD8(esi));
    esi += 1u; edi += 1u;
    ecx -= 1u;
    }
    goto L_4951dd;  /* 0x49552b: jmp 0x4951dd */
L_495530:
    edi = RD32(esp); esp += 4u;  /* 0x495530: pop edi */
    esi = RD32(esp); esp += 4u;  /* 0x495531: pop esi */
    esp = ebp;  /* 0x495532: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x495534: pop ebp */
    esp += 4u; goto done;  /* 0x495535: ret  */
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

/* GAME.EXE 0x4a1358 (179 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4a1358_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4a1358: push ebp */
    ebp = esp;  /* 0x4a1359: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4a135b: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4a135c: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4a135f: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0xdf0u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4a1362: cmp dword ptr [eax + 0xdf0], 0 */
    if ((sf == of)) goto L_4a13bf;  /* 0x4a1369: jge 0x4a13bf */
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4a136b: mov ecx, dword ptr [ebp + 0xc] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4a136e: push ecx */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4a136f: mov edx, dword ptr [ebp + 8] */
    esp -= 4u; WR32(esp, edx);  /* 0x4a1372: push edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4a1373: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0xdf0u));  /* 0x4a1376: mov ecx, dword ptr [eax + 0xdf0] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4a137c: push ecx */
    esp -= 4u; WR32(esp, 0x55020cu);  /* 0x4a137d: push 0x55020c */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4a1382: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4a138cu); FL41_CALL(0x50ca3eu); esp += 4u;  /* 0x4a1387: call 0x50ca3e */
    { uint32_t a_ = esp, b_ = 0x14u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4a138c: add esp, 0x14 */
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4a138f: push 0 */
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4a1391: push 0 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4a1393: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4a139du); FL41_CALL(0x52139cu); esp += 12u; esp += 4u;  /* 0x4a1398: call 0x52139c */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x63a4cdu)))) & 0xffffffffu;  /* 0x4a139d: movsx edx, word ptr [0x63a4cd] */
    { uint32_t a_ = edx, b_ = edx, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4a13a4: test edx, edx */
    if (zf) goto L_4a13b5;  /* 0x4a13a6: je 0x4a13b5 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4a13a8: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4a13b2u); FL41_CALL(0x44a2b7u); esp += 4u;  /* 0x4a13ad: call 0x44a2b7 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4a13b2: add esp, 4 */
L_4a13b5:
    ecx = 0x5cf659u;  /* 0x4a13b5: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4a13bfu); FL41_CALL(0x4c97b4u); esp += 4u;  /* 0x4a13ba: call 0x4c97b4 */
L_4a13bf:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4a13bf: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0xdf0u));  /* 0x4a13c2: mov ecx, dword ptr [eax + 0xdf0] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4a13c8: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0xdecu));  /* 0x4a13cb: mov eax, dword ptr [edx + 0xdec] */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4a13d1: mov edx, dword ptr [ebp + 8] */
    WR32((uint32_t)(eax + ecx * 8u), edx);  /* 0x4a13d4: mov dword ptr [eax + ecx*8], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4a13d7: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0xdf0u));  /* 0x4a13da: mov ecx, dword ptr [eax + 0xdf0] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4a13e0: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0xdecu));  /* 0x4a13e3: mov eax, dword ptr [edx + 0xdec] */
    edx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4a13e9: mov edx, dword ptr [ebp + 0xc] */
    WR32((uint32_t)(eax + ecx * 8u + 0x4u), edx);  /* 0x4a13ec: mov dword ptr [eax + ecx*8 + 4], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4a13f0: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0xdf0u));  /* 0x4a13f3: mov ecx, dword ptr [eax + 0xdf0] */
    { uint32_t a_ = ecx, b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4a13f9: sub ecx, 1 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4a13fc: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0xdf0u), ecx);  /* 0x4a13ff: mov dword ptr [edx + 0xdf0], ecx */
    esp = ebp;  /* 0x4a1405: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4a1407: pop ebp */
    esp += 12u; goto done;  /* 0x4a1408: ret 8 */
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

/* GAME.EXE 0x4a4c15 (320 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4a4c15_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4a4c15: push ebp */
    ebp = esp;  /* 0x4a4c16: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x18u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4a4c18: sub esp, 0x18 */
    WR32((uint32_t)(ebp + 0xffffffe8u), ecx);  /* 0x4a4c1b: mov dword ptr [ebp - 0x18], ecx */
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4a4c1e: mov eax, dword ptr [ebp - 0x18] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x1eu)))) & 0xffffffffu;  /* 0x4a4c21: movsx ecx, word ptr [eax + 0x1e] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4a4c25: imul ecx, ecx, 0x8d */
    edx = RD32((uint32_t)(ecx + 0x5bb5e5u));  /* 0x4a4c2b: mov edx, dword ptr [ecx + 0x5bb5e5] */
    WR32((uint32_t)(ebp + 0xfffffff0u), edx);  /* 0x4a4c31: mov dword ptr [ebp - 0x10], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4a4c34: mov eax, dword ptr [ebp - 0x10] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x48du)))) & 0xffffffffu;  /* 0x4a4c37: movsx ecx, word ptr [eax + 0x48d] */
    { uint32_t a_ = ecx, b_ = ecx, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4a4c3e: test ecx, ecx */
    if (!zf) goto L_4a4c55;  /* 0x4a4c40: jne 0x4a4c55 */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4a4c42: movsx edx, word ptr [ebp + 8] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xcu)))) & 0xffffffffu;  /* 0x4a4c46: movsx eax, word ptr [ebp + 0xc] */
    { uint32_t a_ = edx, b_ = eax, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4a4c4a: cmp edx, eax */
    if (zf) goto L_4a4c55;  /* 0x4a4c4c: je 0x4a4c55 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4a4c4e: xor eax, eax */
    goto L_4a4d4f;  /* 0x4a4c50: jmp 0x4a4d4f */
L_4a4c55:
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4a4c55: movsx ecx, word ptr [ebp + 8] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xcu)))) & 0xffffffffu;  /* 0x4a4c59: movsx edx, word ptr [ebp + 0xc] */
    { uint32_t a_ = ecx, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4a4c5d: cmp ecx, edx */
    if (!zf) goto L_4a4c6b;  /* 0x4a4c5f: jne 0x4a4c6b */
    eax = 0x1u;  /* 0x4a4c61: mov eax, 1 */
    goto L_4a4d4f;  /* 0x4a4c66: jmp 0x4a4d4f */
L_4a4c6b:
    WR32((uint32_t)(ebp + 0xfffffffcu), 0x0u);  /* 0x4a4c6b: mov dword ptr [ebp - 4], 0 */
    WR32((uint32_t)(ebp + 0xfffffff8u), 0x0u);  /* 0x4a4c72: mov dword ptr [ebp - 8], 0 */
    WR16((uint32_t)(ebp + 0xffffffecu), 0x0u);  /* 0x4a4c79: mov word ptr [ebp - 0x14], 0 */
    goto L_4a4c8d;  /* 0x4a4c7f: jmp 0x4a4c8d */
L_4a4c81:
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xffffffecu))) & 0xffffu);  /* 0x4a4c81: mov ax, word ptr [ebp - 0x14] */
    { uint32_t a_ = (eax & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); eax = (eax & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4a4c85: add ax, 1 */
    WR16((uint32_t)(ebp + 0xffffffecu), (eax & 0xffffu));  /* 0x4a4c89: mov word ptr [ebp - 0x14], ax */
L_4a4c8d:
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4a4c8d: movsx ecx, word ptr [ebp - 0x14] */
    edx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4a4c91: mov edx, dword ptr [ebp - 0x10] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x48du)))) & 0xffffffffu;  /* 0x4a4c94: movsx eax, word ptr [edx + 0x48d] */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4a4c9b: cmp ecx, eax */
    if ((sf == of)) goto L_4a4d4d;  /* 0x4a4c9d: jge 0x4a4d4d */
    WR16((uint32_t)(ebp + 0xfffffff4u), 0x0u);  /* 0x4a4ca3: mov word ptr [ebp - 0xc], 0 */
    goto L_4a4cb7;  /* 0x4a4ca9: jmp 0x4a4cb7 */
L_4a4cab:
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffff4u))) & 0xffffu);  /* 0x4a4cab: mov cx, word ptr [ebp - 0xc] */
    { uint32_t a_ = (ecx & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); ecx = (ecx & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4a4caf: add cx, 1 */
    WR16((uint32_t)(ebp + 0xfffffff4u), (ecx & 0xffffu));  /* 0x4a4cb3: mov word ptr [ebp - 0xc], cx */
L_4a4cb7:
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4a4cb7: movsx edx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0xau); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4a4cbb: imul edx, edx, 0xa */
    eax = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4a4cbe: mov eax, dword ptr [ebp - 0x10] */
    ecx = (uint32_t)(eax + edx + 0x48fu);  /* 0x4a4cc1: lea ecx, [eax + edx + 0x48f] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff4u)))) & 0xffffffffu;  /* 0x4a4cc8: movsx edx, word ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + edx * 2u)))) & 0xffffffffu;  /* 0x4a4ccc: movsx eax, word ptr [ecx + edx*2] */
    { uint32_t a_ = eax, b_ = 0xffffffffu, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4a4cd0: cmp eax, -1 */
    if (zf) goto L_4a4d27;  /* 0x4a4cd3: je 0x4a4d27 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4a4cd5: movsx ecx, word ptr [ebp + 8] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4a4cd9: movsx edx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0xau); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4a4cdd: imul edx, edx, 0xa */
    eax = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4a4ce0: mov eax, dword ptr [ebp - 0x10] */
    edx = (uint32_t)(eax + edx + 0x48fu);  /* 0x4a4ce3: lea edx, [eax + edx + 0x48f] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff4u)))) & 0xffffffffu;  /* 0x4a4cea: movsx eax, word ptr [ebp - 0xc] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + eax * 2u)))) & 0xffffffffu;  /* 0x4a4cee: movsx edx, word ptr [edx + eax*2] */
    { uint32_t a_ = ecx, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4a4cf2: cmp ecx, edx */
    if (!zf) goto L_4a4cfd;  /* 0x4a4cf4: jne 0x4a4cfd */
    WR32((uint32_t)(ebp + 0xfffffffcu), 0x1u);  /* 0x4a4cf6: mov dword ptr [ebp - 4], 1 */
L_4a4cfd:
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xcu)))) & 0xffffffffu;  /* 0x4a4cfd: movsx eax, word ptr [ebp + 0xc] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4a4d01: movsx ecx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0xau); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4a4d05: imul ecx, ecx, 0xa */
    edx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4a4d08: mov edx, dword ptr [ebp - 0x10] */
    ecx = (uint32_t)(edx + ecx + 0x48fu);  /* 0x4a4d0b: lea ecx, [edx + ecx + 0x48f] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff4u)))) & 0xffffffffu;  /* 0x4a4d12: movsx edx, word ptr [ebp - 0xc] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + edx * 2u)))) & 0xffffffffu;  /* 0x4a4d16: movsx ecx, word ptr [ecx + edx*2] */
    { uint32_t a_ = eax, b_ = ecx, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4a4d1a: cmp eax, ecx */
    if (!zf) goto L_4a4d25;  /* 0x4a4d1c: jne 0x4a4d25 */
    WR32((uint32_t)(ebp + 0xfffffff8u), 0x1u);  /* 0x4a4d1e: mov dword ptr [ebp - 8], 1 */
L_4a4d25:
    goto L_4a4cab;  /* 0x4a4d25: jmp 0x4a4cab */
L_4a4d27:
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffffcu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4a4d27: cmp dword ptr [ebp - 4], 0 */
    if (zf) goto L_4a4d3a;  /* 0x4a4d2b: je 0x4a4d3a */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffff8u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4a4d2d: cmp dword ptr [ebp - 8], 0 */
    if (zf) goto L_4a4d3a;  /* 0x4a4d31: je 0x4a4d3a */
    eax = 0x1u;  /* 0x4a4d33: mov eax, 1 */
    goto L_4a4d4f;  /* 0x4a4d38: jmp 0x4a4d4f */
L_4a4d3a:
    WR32((uint32_t)(ebp + 0xfffffffcu), 0x0u);  /* 0x4a4d3a: mov dword ptr [ebp - 4], 0 */
    WR32((uint32_t)(ebp + 0xfffffff8u), 0x0u);  /* 0x4a4d41: mov dword ptr [ebp - 8], 0 */
    goto L_4a4c81;  /* 0x4a4d48: jmp 0x4a4c81 */
L_4a4d4d:
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4a4d4d: xor eax, eax */
L_4a4d4f:
    esp = ebp;  /* 0x4a4d4f: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4a4d51: pop ebp */
    esp += 12u; goto done;  /* 0x4a4d52: ret 8 */
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

/* GAME.EXE 0x4aa002 (238 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4aa002_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4aa002: push ebp */
    ebp = esp;  /* 0x4aa003: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x10u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4aa005: sub esp, 0x10 */
    esp -= 4u; WR32(esp, esi);  /* 0x4aa008: push esi */
    esp -= 4u; WR32(esp, edi);  /* 0x4aa009: push edi */
    WR32((uint32_t)(ebp + 0xfffffff0u), ecx);  /* 0x4aa00a: mov dword ptr [ebp - 0x10], ecx */
    eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x4aa00d: mov eax, dword ptr [ebp + 0xc] */
    ecx = RD32((uint32_t)(eax));  /* 0x4aa010: mov ecx, dword ptr [eax] */
    WR32((uint32_t)(ebp + 0xfffffff8u), ecx);  /* 0x4aa012: mov dword ptr [ebp - 8], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4aa015: mov edx, dword ptr [ebp - 8] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0xf7u)))) & 0xffffffffu;  /* 0x4aa018: movsx eax, word ptr [edx + 0xf7] */
    ecx = 0x14u;  /* 0x4aa01f: mov ecx, 0x14 */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4aa024: sub ecx, eax */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x15cu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4aa026: imul ecx, ecx, 0x15c */
    edx = 0x1c29u;  /* 0x4aa02c: mov edx, 0x1c29 */
    { uint32_t a_ = edx, b_ = ecx, r_; FL41_SUB(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4aa031: sub edx, ecx */
    WR16((uint32_t)(ebp + 0xfffffffcu), (edx & 0xffffu));  /* 0x4aa033: mov word ptr [ebp - 4], dx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4aa037: movsx eax, word ptr [ebp - 4] */
    esp -= 4u; WR32(esp, eax);  /* 0x4aa03b: push eax */
    esp -= 4u; WR32(esp, 0x4aa041u); FL41_CALL(0x51dc43u); esp += 4u;  /* 0x4aa03c: call 0x51dc43 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4aa041: add esp, 4 */
    WR32((uint32_t)(ebp + 0xfffffff4u), eax);  /* 0x4aa044: mov dword ptr [ebp - 0xc], eax */
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4aa047: mov ecx, dword ptr [ebp + 8] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4aa04a: mov edx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx), edx);  /* 0x4aa04d: mov dword ptr [ecx], edx */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffff4u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4aa04f: cmp dword ptr [ebp - 0xc], 0 */
    if (!zf) goto L_4aa094;  /* 0x4aa053: jne 0x4aa094 */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x5c39e3u)))) & 0xffffffffu;  /* 0x4aa055: movsx eax, word ptr [0x5c39e3] */
    esp -= 4u; WR32(esp, eax);  /* 0x4aa05c: push eax */
    ecx = RD32((uint32_t)(0x5bb57bu));  /* 0x4aa05d: mov ecx, dword ptr [0x5bb57b] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4aa063: push ecx */
    esp -= 4u; WR32(esp, 0x550dbcu);  /* 0x4aa064: push 0x550dbc */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4aa069: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4aa073u); FL41_CALL(0x50ca3eu); esp += 4u;  /* 0x4aa06e: call 0x50ca3e */
    { uint32_t a_ = esp, b_ = 0x10u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4aa073: add esp, 0x10 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4aa076: push 0x63888b */
    esp -= 4u; WR32(esp, 0x550de8u);  /* 0x4aa07b: push 0x550de8 */
    ecx = 0x583979u;  /* 0x4aa080: mov ecx, 0x583979 */
    esp -= 4u; WR32(esp, 0x4aa08au); FL41_CALL(0x42639du); esp += 8u; esp += 4u;  /* 0x4aa085: call 0x42639d */
    ecx = 0x5cf659u;  /* 0x4aa08a: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4aa094u); FL41_CALL(0x4c97b4u); esp += 4u;  /* 0x4aa08f: call 0x4c97b4 */
L_4aa094:
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4aa094: movsx ecx, word ptr [ebp - 4] */
    edx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4aa098: mov edx, dword ptr [ebp + 0xc] */
    esi = RD32((uint32_t)(edx));  /* 0x4aa09b: mov esi, dword ptr [edx] */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4aa09d: mov eax, dword ptr [ebp + 8] */
    edi = RD32((uint32_t)(eax));  /* 0x4aa0a0: mov edi, dword ptr [eax] */
    edx = ecx;  /* 0x4aa0a2: mov edx, ecx */
    { uint32_t a_ = ecx, n_ = 0x2u, r_; if (n_ != 0u) { FL41_SHR(r_, a_, n_, 32); ecx = r_; } }  /* 0x4aa0a4: shr ecx, 2 */
    /* 0x4aa0a7: rep movsd dword ptr es:[edi], dword ptr [esi] */
    while (ecx != 0u) {
    WR32(edi, RD32(esi));
    esi += 4u; edi += 4u;
    ecx -= 1u;
    }
    ecx = edx;  /* 0x4aa0a9: mov ecx, edx */
    { uint32_t a_ = ecx, b_ = 0x3u, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x4aa0ab: and ecx, 3 */
    /* 0x4aa0ae: rep movsb byte ptr es:[edi], byte ptr [esi] */
    while (ecx != 0u) {
    WR8(edi, RD8(esi));
    esi += 1u; edi += 1u;
    ecx -= 1u;
    }
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4aa0b0: movsx eax, word ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4aa0b4: mov ecx, dword ptr [ebp + 0x10] */
    edx = RD32((uint32_t)(ecx));  /* 0x4aa0b7: mov edx, dword ptr [ecx] */
    { uint32_t a_ = edx, b_ = eax, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4aa0b9: add edx, eax */
    eax = RD32((uint32_t)(ebp + 0x10u));  /* 0x4aa0bb: mov eax, dword ptr [ebp + 0x10] */
    WR32((uint32_t)(eax), edx);  /* 0x4aa0be: mov dword ptr [eax], edx */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4aa0c0: movsx ecx, word ptr [ebp - 4] */
    edx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4aa0c4: mov edx, dword ptr [ebp + 0xc] */
    eax = RD32((uint32_t)(edx));  /* 0x4aa0c7: mov eax, dword ptr [edx] */
    { uint32_t a_ = eax, b_ = ecx, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4aa0c9: add eax, ecx */
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4aa0cb: mov ecx, dword ptr [ebp + 0xc] */
    WR32((uint32_t)(ecx), eax);  /* 0x4aa0ce: mov dword ptr [ecx], eax */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x63a4cdu)))) & 0xffffffffu;  /* 0x4aa0d0: movsx edx, word ptr [0x63a4cd] */
    { uint32_t a_ = edx, b_ = edx, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4aa0d7: test edx, edx */
    if (zf) goto L_4aa0e8;  /* 0x4aa0d9: je 0x4aa0e8 */
    esp -= 4u; WR32(esp, 0x550e04u);  /* 0x4aa0db: push 0x550e04 */
    esp -= 4u; WR32(esp, 0x4aa0e5u); FL41_CALL(0x44a2b7u); esp += 4u;  /* 0x4aa0e0: call 0x44a2b7 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4aa0e5: add esp, 4 */
L_4aa0e8:
    edi = RD32(esp); esp += 4u;  /* 0x4aa0e8: pop edi */
    esi = RD32(esp); esp += 4u;  /* 0x4aa0e9: pop esi */
    esp = ebp;  /* 0x4aa0ea: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4aa0ec: pop ebp */
    esp += 16u; goto done;  /* 0x4aa0ed: ret 0xc */
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

/* GAME.EXE 0x4ab9fa (115 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4ab9fa_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4ab9fa: push ebp */
    ebp = esp;  /* 0x4ab9fb: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0xcu, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4ab9fd: sub esp, 0xc */
    WR32((uint32_t)(ebp + 0xfffffff4u), ecx);  /* 0x4aba00: mov dword ptr [ebp - 0xc], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4aba03: mov eax, dword ptr [ebp - 0xc] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x1eu)))) & 0xffffffffu;  /* 0x4aba06: movsx ecx, word ptr [eax + 0x1e] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4aba0a: imul ecx, ecx, 0x8d */
    edx = RD32((uint32_t)(ecx + 0x5bb5e5u));  /* 0x4aba10: mov edx, dword ptr [ecx + 0x5bb5e5] */
    WR32((uint32_t)(ebp + 0xfffffff8u), edx);  /* 0x4aba16: mov dword ptr [ebp - 8], edx */
    WR32((uint32_t)(ebp + 0xfffffffcu), 0x0u);  /* 0x4aba19: mov dword ptr [ebp - 4], 0 */
    goto L_4aba2b;  /* 0x4aba20: jmp 0x4aba2b */
L_4aba22:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4aba22: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4aba25: add eax, 1 */
    WR32((uint32_t)(ebp + 0xfffffffcu), eax);  /* 0x4aba28: mov dword ptr [ebp - 4], eax */
L_4aba2b:
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4aba2b: mov ecx, dword ptr [ebp - 8] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0x21u)))) & 0xffffffffu;  /* 0x4aba2e: movsx edx, word ptr [ecx + 0x21] */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffffcu)), b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4aba32: cmp dword ptr [ebp - 4], edx */
    if ((sf == of)) goto L_4aba58;  /* 0x4aba35: jge 0x4aba58 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4aba37: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4aba3a: mov ecx, dword ptr [ebp - 0xc] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + eax * 2u + 0x48u)))) & 0xffffffffu;  /* 0x4aba3d: movsx edx, word ptr [ecx + eax*2 + 0x48] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4aba42: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4aba45: mov ecx, dword ptr [ebp - 8] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + eax * 2u + 0xaabu)))) & 0xffffffffu;  /* 0x4aba48: movsx eax, word ptr [ecx + eax*2 + 0xaab] */
    { uint32_t a_ = edx, b_ = eax, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4aba50: cmp edx, eax */
    if (zf) goto L_4aba56;  /* 0x4aba52: je 0x4aba56 */
    goto L_4aba69;  /* 0x4aba54: jmp 0x4aba69 */
L_4aba56:
    goto L_4aba22;  /* 0x4aba56: jmp 0x4aba22 */
L_4aba58:
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4aba58: mov ecx, dword ptr [ebp - 0xc] */
    WR8((uint32_t)(ecx + 0x59u), 0x1u);  /* 0x4aba5b: mov byte ptr [ecx + 0x59], 1 */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4aba5f: mov edx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(edx + 0x5eu), 0x1u);  /* 0x4aba62: mov dword ptr [edx + 0x5e], 1 */
L_4aba69:
    esp = ebp;  /* 0x4aba69: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4aba6b: pop ebp */
    esp += 4u; goto done;  /* 0x4aba6c: ret  */
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

/* GAME.EXE 0x4ae96c (713 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4ae96c_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4ae96c: push ebp */
    ebp = esp;  /* 0x4ae96d: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x6cu, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4ae96f: sub esp, 0x6c */
    WR32((uint32_t)(ebp + 0xffffff94u), ecx);  /* 0x4ae972: mov dword ptr [ebp - 0x6c], ecx */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4ae975: mov eax, dword ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0xc7u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ae978: imul eax, eax, 0xc7 */
    ecx = RD32((uint32_t)(ebp + 0xffffff94u));  /* 0x4ae97e: mov ecx, dword ptr [ebp - 0x6c] */
    edx = (uint32_t)(ecx + eax + 0x6eu);  /* 0x4ae981: lea edx, [ecx + eax + 0x6e] */
    WR32((uint32_t)(ebp + 0xffffff9cu), edx);  /* 0x4ae985: mov dword ptr [ebp - 0x64], edx */
    eax = RD32((uint32_t)(ebp + 0xffffff9cu));  /* 0x4ae988: mov eax, dword ptr [ebp - 0x64] */
    { uint32_t a_ = ecx, b_ = ecx, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x4ae98b: xor ecx, ecx */
    ecx = (ecx & 0xffffff00u) | ((RD8((uint32_t)(eax + 0x26u))) & 0xffu);  /* 0x4ae98d: mov cl, byte ptr [eax + 0x26] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x28u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ae990: imul ecx, ecx, 0x28 */
    edx = RD32((uint32_t)(ebp + 0xffffff9cu));  /* 0x4ae993: mov edx, dword ptr [ebp - 0x64] */
    eax = (uint32_t)(edx + ecx + 0x27u);  /* 0x4ae996: lea eax, [edx + ecx + 0x27] */
    WR32((uint32_t)(ebp + 0xffffffb8u), eax);  /* 0x4ae99a: mov dword ptr [ebp - 0x48], eax */
    ecx = RD32((uint32_t)(ebp + 0xffffff9cu));  /* 0x4ae99d: mov ecx, dword ptr [ebp - 0x64] */
    { uint32_t a_ = ecx, b_ = 0x2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4ae9a0: add ecx, 2 */
    WR32((uint32_t)(ebp + 0xffffffbcu), ecx);  /* 0x4ae9a3: mov dword ptr [ebp - 0x44], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffb8u));  /* 0x4ae9a6: mov edx, dword ptr [ebp - 0x48] */
    eax = RD32((uint32_t)(edx + 0x1cu));  /* 0x4ae9a9: mov eax, dword ptr [edx + 0x1c] */
    WR32((uint32_t)(ebp + 0xffffffecu), eax);  /* 0x4ae9ac: mov dword ptr [ebp - 0x14], eax */
    ecx = RD32((uint32_t)(ebp + 0xffffffb8u));  /* 0x4ae9af: mov ecx, dword ptr [ebp - 0x48] */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ecx + 0x20u))) & 0xffffu);  /* 0x4ae9b2: mov dx, word ptr [ecx + 0x20] */
    WR16((uint32_t)(ebp + 0xfffffff0u), (edx & 0xffffu));  /* 0x4ae9b6: mov word ptr [ebp - 0x10], dx */
    eax = RD32((uint32_t)(ebp + 0xffffff94u));  /* 0x4ae9ba: mov eax, dword ptr [ebp - 0x6c] */
    ecx = RD32((uint32_t)(eax + 0xe6du));  /* 0x4ae9bd: mov ecx, dword ptr [eax + 0xe6d] */
    WR32((uint32_t)(ebp + 0xffffffb0u), ecx);  /* 0x4ae9c3: mov dword ptr [ebp - 0x50], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffff94u));  /* 0x4ae9c6: mov edx, dword ptr [ebp - 0x6c] */
    { uint32_t a_ = edx, b_ = 0xe79u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4ae9c9: add edx, 0xe79 */
    WR32((uint32_t)(ebp + 0xffffffe8u), edx);  /* 0x4ae9cf: mov dword ptr [ebp - 0x18], edx */
    eax = RD32((uint32_t)(ebp + 0xffffff94u));  /* 0x4ae9d2: mov eax, dword ptr [ebp - 0x6c] */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(eax + 0xe71u))) & 0xffffu);  /* 0x4ae9d5: mov cx, word ptr [eax + 0xe71] */
    WR16((uint32_t)(ebp + 0xfffffff8u), (ecx & 0xffffu));  /* 0x4ae9dc: mov word ptr [ebp - 8], cx */
    { uint32_t a_ = edx, b_ = 0xffffffffu, r_; r_ = a_ | b_; FL41_LOGIC(r_, 32); edx = r_; }  /* 0x4ae9e0: or edx, 0xffffffff */
    WR32((uint32_t)(ebp + 0xffffffd4u), edx);  /* 0x4ae9e3: mov dword ptr [ebp - 0x2c], edx */
    WR32((uint32_t)(ebp + 0xffffffd8u), edx);  /* 0x4ae9e6: mov dword ptr [ebp - 0x28], edx */
    WR32((uint32_t)(ebp + 0xffffffdcu), edx);  /* 0x4ae9e9: mov dword ptr [ebp - 0x24], edx */
    WR32((uint32_t)(ebp + 0xffffffe0u), edx);  /* 0x4ae9ec: mov dword ptr [ebp - 0x20], edx */
    eax = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4ae9ef: mov eax, dword ptr [ebp - 0x44] */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ae9f2: mov ecx, dword ptr [ebp - 0x18] */
    edx = RD32((uint32_t)(eax));  /* 0x4ae9f5: mov edx, dword ptr [eax] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ecx)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ae9f7: cmp edx, dword ptr [ecx] */
    if ((sf == of)) goto L_4aea3b;  /* 0x4ae9f9: jge 0x4aea3b */
    eax = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4ae9fb: mov eax, dword ptr [ebp - 0x44] */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ae9fe: mov ecx, dword ptr [ebp - 0x18] */
    edx = RD32((uint32_t)(eax + 0x8u));  /* 0x4aea01: mov edx, dword ptr [eax + 8] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ecx)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4aea04: cmp edx, dword ptr [ecx] */
    if ((sf != of)) goto L_4aea34;  /* 0x4aea06: jl 0x4aea34 */
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4aea08: mov eax, dword ptr [ebp - 0x18] */
    ecx = RD32((uint32_t)(eax));  /* 0x4aea0b: mov ecx, dword ptr [eax] */
    WR32((uint32_t)(ebp + 0xffffffd4u), ecx);  /* 0x4aea0d: mov dword ptr [ebp - 0x2c], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4aea10: mov edx, dword ptr [ebp - 0x44] */
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4aea13: mov eax, dword ptr [ebp - 0x18] */
    ecx = RD32((uint32_t)(edx + 0x8u));  /* 0x4aea16: mov ecx, dword ptr [edx + 8] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(eax + 0x8u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4aea19: cmp ecx, dword ptr [eax + 8] */
    if ((zf || sf != of)) goto L_4aea29;  /* 0x4aea1c: jle 0x4aea29 */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4aea1e: mov edx, dword ptr [ebp - 0x18] */
    eax = RD32((uint32_t)(edx + 0x8u));  /* 0x4aea21: mov eax, dword ptr [edx + 8] */
    WR32((uint32_t)(ebp + 0xffffffdcu), eax);  /* 0x4aea24: mov dword ptr [ebp - 0x24], eax */
    goto L_4aea32;  /* 0x4aea27: jmp 0x4aea32 */
L_4aea29:
    ecx = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4aea29: mov ecx, dword ptr [ebp - 0x44] */
    edx = RD32((uint32_t)(ecx + 0x8u));  /* 0x4aea2c: mov edx, dword ptr [ecx + 8] */
    WR32((uint32_t)(ebp + 0xffffffdcu), edx);  /* 0x4aea2f: mov dword ptr [ebp - 0x24], edx */
L_4aea32:
    goto L_4aea39;  /* 0x4aea32: jmp 0x4aea39 */
L_4aea34:
    goto L_4aec2f;  /* 0x4aea34: jmp 0x4aec2f */
L_4aea39:
    goto L_4aea79;  /* 0x4aea39: jmp 0x4aea79 */
L_4aea3b:
    eax = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4aea3b: mov eax, dword ptr [ebp - 0x44] */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4aea3e: mov ecx, dword ptr [ebp - 0x18] */
    edx = RD32((uint32_t)(eax));  /* 0x4aea41: mov edx, dword ptr [eax] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ecx + 0x8u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4aea43: cmp edx, dword ptr [ecx + 8] */
    if ((!zf && sf == of)) goto L_4aea74;  /* 0x4aea46: jg 0x4aea74 */
    eax = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4aea48: mov eax, dword ptr [ebp - 0x44] */
    ecx = RD32((uint32_t)(eax));  /* 0x4aea4b: mov ecx, dword ptr [eax] */
    WR32((uint32_t)(ebp + 0xffffffd4u), ecx);  /* 0x4aea4d: mov dword ptr [ebp - 0x2c], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4aea50: mov edx, dword ptr [ebp - 0x44] */
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4aea53: mov eax, dword ptr [ebp - 0x18] */
    ecx = RD32((uint32_t)(edx + 0x8u));  /* 0x4aea56: mov ecx, dword ptr [edx + 8] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(eax + 0x8u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4aea59: cmp ecx, dword ptr [eax + 8] */
    if ((!zf && sf == of)) goto L_4aea69;  /* 0x4aea5c: jg 0x4aea69 */
    edx = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4aea5e: mov edx, dword ptr [ebp - 0x44] */
    eax = RD32((uint32_t)(edx + 0x8u));  /* 0x4aea61: mov eax, dword ptr [edx + 8] */
    WR32((uint32_t)(ebp + 0xffffffdcu), eax);  /* 0x4aea64: mov dword ptr [ebp - 0x24], eax */
    goto L_4aea72;  /* 0x4aea67: jmp 0x4aea72 */
L_4aea69:
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4aea69: mov ecx, dword ptr [ebp - 0x18] */
    edx = RD32((uint32_t)(ecx + 0x8u));  /* 0x4aea6c: mov edx, dword ptr [ecx + 8] */
    WR32((uint32_t)(ebp + 0xffffffdcu), edx);  /* 0x4aea6f: mov dword ptr [ebp - 0x24], edx */
L_4aea72:
    goto L_4aea79;  /* 0x4aea72: jmp 0x4aea79 */
L_4aea74:
    goto L_4aec2f;  /* 0x4aea74: jmp 0x4aec2f */
L_4aea79:
    eax = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4aea79: mov eax, dword ptr [ebp - 0x44] */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4aea7c: mov ecx, dword ptr [ebp - 0x18] */
    edx = RD32((uint32_t)(eax + 0x4u));  /* 0x4aea7f: mov edx, dword ptr [eax + 4] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ecx + 0x4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4aea82: cmp edx, dword ptr [ecx + 4] */
    if ((sf == of)) goto L_4aeac9;  /* 0x4aea85: jge 0x4aeac9 */
    eax = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4aea87: mov eax, dword ptr [ebp - 0x44] */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4aea8a: mov ecx, dword ptr [ebp - 0x18] */
    edx = RD32((uint32_t)(eax + 0xcu));  /* 0x4aea8d: mov edx, dword ptr [eax + 0xc] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ecx + 0x4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4aea90: cmp edx, dword ptr [ecx + 4] */
    if ((sf != of)) goto L_4aeac2;  /* 0x4aea93: jl 0x4aeac2 */
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4aea95: mov eax, dword ptr [ebp - 0x18] */
    ecx = RD32((uint32_t)(eax + 0x4u));  /* 0x4aea98: mov ecx, dword ptr [eax + 4] */
    WR32((uint32_t)(ebp + 0xffffffd8u), ecx);  /* 0x4aea9b: mov dword ptr [ebp - 0x28], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4aea9e: mov edx, dword ptr [ebp - 0x44] */
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4aeaa1: mov eax, dword ptr [ebp - 0x18] */
    ecx = RD32((uint32_t)(edx + 0xcu));  /* 0x4aeaa4: mov ecx, dword ptr [edx + 0xc] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(eax + 0xcu)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4aeaa7: cmp ecx, dword ptr [eax + 0xc] */
    if ((zf || sf != of)) goto L_4aeab7;  /* 0x4aeaaa: jle 0x4aeab7 */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4aeaac: mov edx, dword ptr [ebp - 0x18] */
    eax = RD32((uint32_t)(edx + 0xcu));  /* 0x4aeaaf: mov eax, dword ptr [edx + 0xc] */
    WR32((uint32_t)(ebp + 0xffffffe0u), eax);  /* 0x4aeab2: mov dword ptr [ebp - 0x20], eax */
    goto L_4aeac0;  /* 0x4aeab5: jmp 0x4aeac0 */
L_4aeab7:
    ecx = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4aeab7: mov ecx, dword ptr [ebp - 0x44] */
    edx = RD32((uint32_t)(ecx + 0xcu));  /* 0x4aeaba: mov edx, dword ptr [ecx + 0xc] */
    WR32((uint32_t)(ebp + 0xffffffe0u), edx);  /* 0x4aeabd: mov dword ptr [ebp - 0x20], edx */
L_4aeac0:
    goto L_4aeac7;  /* 0x4aeac0: jmp 0x4aeac7 */
L_4aeac2:
    goto L_4aec2f;  /* 0x4aeac2: jmp 0x4aec2f */
L_4aeac7:
    goto L_4aeb09;  /* 0x4aeac7: jmp 0x4aeb09 */
L_4aeac9:
    eax = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4aeac9: mov eax, dword ptr [ebp - 0x44] */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4aeacc: mov ecx, dword ptr [ebp - 0x18] */
    edx = RD32((uint32_t)(eax + 0x4u));  /* 0x4aeacf: mov edx, dword ptr [eax + 4] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ecx + 0xcu)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4aead2: cmp edx, dword ptr [ecx + 0xc] */
    if ((!zf && sf == of)) goto L_4aeb04;  /* 0x4aead5: jg 0x4aeb04 */
    eax = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4aead7: mov eax, dword ptr [ebp - 0x44] */
    ecx = RD32((uint32_t)(eax + 0x4u));  /* 0x4aeada: mov ecx, dword ptr [eax + 4] */
    WR32((uint32_t)(ebp + 0xffffffd8u), ecx);  /* 0x4aeadd: mov dword ptr [ebp - 0x28], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4aeae0: mov edx, dword ptr [ebp - 0x44] */
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4aeae3: mov eax, dword ptr [ebp - 0x18] */
    ecx = RD32((uint32_t)(edx + 0xcu));  /* 0x4aeae6: mov ecx, dword ptr [edx + 0xc] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(eax + 0xcu)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4aeae9: cmp ecx, dword ptr [eax + 0xc] */
    if ((!zf && sf == of)) goto L_4aeaf9;  /* 0x4aeaec: jg 0x4aeaf9 */
    edx = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4aeaee: mov edx, dword ptr [ebp - 0x44] */
    eax = RD32((uint32_t)(edx + 0xcu));  /* 0x4aeaf1: mov eax, dword ptr [edx + 0xc] */
    WR32((uint32_t)(ebp + 0xffffffe0u), eax);  /* 0x4aeaf4: mov dword ptr [ebp - 0x20], eax */
    goto L_4aeb02;  /* 0x4aeaf7: jmp 0x4aeb02 */
L_4aeaf9:
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4aeaf9: mov ecx, dword ptr [ebp - 0x18] */
    edx = RD32((uint32_t)(ecx + 0xcu));  /* 0x4aeafc: mov edx, dword ptr [ecx + 0xc] */
    WR32((uint32_t)(ebp + 0xffffffe0u), edx);  /* 0x4aeaff: mov dword ptr [ebp - 0x20], edx */
L_4aeb02:
    goto L_4aeb09;  /* 0x4aeb02: jmp 0x4aeb09 */
L_4aeb04:
    goto L_4aec2f;  /* 0x4aeb04: jmp 0x4aec2f */
L_4aeb09:
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xffffffd8u)), b_ = 0xffffffffu, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4aeb09: cmp dword ptr [ebp - 0x28], -1 */
    if (zf) goto L_4aeb21;  /* 0x4aeb0d: je 0x4aeb21 */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xffffffe0u)), b_ = 0xffffffffu, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4aeb0f: cmp dword ptr [ebp - 0x20], -1 */
    if (zf) goto L_4aeb21;  /* 0x4aeb13: je 0x4aeb21 */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xffffffd4u)), b_ = 0xffffffffu, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4aeb15: cmp dword ptr [ebp - 0x2c], -1 */
    if (zf) goto L_4aeb21;  /* 0x4aeb19: je 0x4aeb21 */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xffffffdcu)), b_ = 0xffffffffu, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4aeb1b: cmp dword ptr [ebp - 0x24], -1 */
    if (!zf) goto L_4aeb26;  /* 0x4aeb1f: jne 0x4aeb26 */
L_4aeb21:
    goto L_4aec2f;  /* 0x4aeb21: jmp 0x4aec2f */
L_4aeb26:
    eax = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4aeb26: mov eax, dword ptr [ebp - 0x44] */
    ecx = RD32((uint32_t)(ebp + 0xffffffd4u));  /* 0x4aeb29: mov ecx, dword ptr [ebp - 0x2c] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(eax)), r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4aeb2c: sub ecx, dword ptr [eax] */
    WR32((uint32_t)(ebp + 0xffffffa8u), ecx);  /* 0x4aeb2e: mov dword ptr [ebp - 0x58], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4aeb31: mov edx, dword ptr [ebp - 0x44] */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4aeb34: mov eax, dword ptr [ebp - 0x24] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(edx)), r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4aeb37: sub eax, dword ptr [edx] */
    WR32((uint32_t)(ebp + 0xffffffc4u), eax);  /* 0x4aeb39: mov dword ptr [ebp - 0x3c], eax */
    ecx = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4aeb3c: mov ecx, dword ptr [ebp - 0x44] */
    edx = RD32((uint32_t)(ebp + 0xffffffd8u));  /* 0x4aeb3f: mov edx, dword ptr [ebp - 0x28] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ecx + 0x4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4aeb42: sub edx, dword ptr [ecx + 4] */
    WR32((uint32_t)(ebp + 0xffffffa4u), edx);  /* 0x4aeb45: mov dword ptr [ebp - 0x5c], edx */
    eax = RD32((uint32_t)(ebp + 0xffffffbcu));  /* 0x4aeb48: mov eax, dword ptr [ebp - 0x44] */
    ecx = RD32((uint32_t)(ebp + 0xffffffe0u));  /* 0x4aeb4b: mov ecx, dword ptr [ebp - 0x20] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(eax + 0x4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4aeb4e: sub ecx, dword ptr [eax + 4] */
    WR32((uint32_t)(ebp + 0xfffffff4u), ecx);  /* 0x4aeb51: mov dword ptr [ebp - 0xc], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4aeb54: mov edx, dword ptr [ebp - 0x18] */
    eax = RD32((uint32_t)(ebp + 0xffffffd4u));  /* 0x4aeb57: mov eax, dword ptr [ebp - 0x2c] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(edx)), r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4aeb5a: sub eax, dword ptr [edx] */
    WR32((uint32_t)(ebp + 0xffffff98u), eax);  /* 0x4aeb5c: mov dword ptr [ebp - 0x68], eax */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4aeb5f: mov ecx, dword ptr [ebp - 0x18] */
    edx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4aeb62: mov edx, dword ptr [ebp - 0x24] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ecx)), r_; FL41_SUB(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4aeb65: sub edx, dword ptr [ecx] */
    WR32((uint32_t)(ebp + 0xffffffb4u), edx);  /* 0x4aeb67: mov dword ptr [ebp - 0x4c], edx */
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4aeb6a: mov eax, dword ptr [ebp - 0x18] */
    ecx = RD32((uint32_t)(ebp + 0xffffffd8u));  /* 0x4aeb6d: mov ecx, dword ptr [ebp - 0x28] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(eax + 0x4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4aeb70: sub ecx, dword ptr [eax + 4] */
    WR32((uint32_t)(ebp + 0xffffffa0u), ecx);  /* 0x4aeb73: mov dword ptr [ebp - 0x60], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4aeb76: mov edx, dword ptr [ebp - 0x18] */
    eax = RD32((uint32_t)(ebp + 0xffffffe0u));  /* 0x4aeb79: mov eax, dword ptr [ebp - 0x20] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(edx + 0x4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4aeb7c: sub eax, dword ptr [edx + 4] */
    WR32((uint32_t)(ebp + 0xffffffacu), eax);  /* 0x4aeb7f: mov dword ptr [ebp - 0x54], eax */
    ecx = RD32((uint32_t)(ebp + 0xffffffa4u));  /* 0x4aeb82: mov ecx, dword ptr [ebp - 0x5c] */
    WR32((uint32_t)(ebp + 0xffffffc8u), ecx);  /* 0x4aeb85: mov dword ptr [ebp - 0x38], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffa0u));  /* 0x4aeb88: mov edx, dword ptr [ebp - 0x60] */
    WR32((uint32_t)(ebp + 0xffffffd0u), edx);  /* 0x4aeb8b: mov dword ptr [ebp - 0x30], edx */
    goto L_4aeba2;  /* 0x4aeb8e: jmp 0x4aeba2 */
L_4aeb90:
    eax = RD32((uint32_t)(ebp + 0xffffffc8u));  /* 0x4aeb90: mov eax, dword ptr [ebp - 0x38] */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4aeb93: add eax, 1 */
    WR32((uint32_t)(ebp + 0xffffffc8u), eax);  /* 0x4aeb96: mov dword ptr [ebp - 0x38], eax */
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x4aeb99: mov ecx, dword ptr [ebp - 0x30] */
    { uint32_t a_ = ecx, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4aeb9c: add ecx, 1 */
    WR32((uint32_t)(ebp + 0xffffffd0u), ecx);  /* 0x4aeb9f: mov dword ptr [ebp - 0x30], ecx */
L_4aeba2:
    edx = RD32((uint32_t)(ebp + 0xffffffc8u));  /* 0x4aeba2: mov edx, dword ptr [ebp - 0x38] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ebp + 0xfffffff4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4aeba5: cmp edx, dword ptr [ebp - 0xc] */
    if ((!zf && sf == of)) goto L_4aec2f;  /* 0x4aeba8: jg 0x4aec2f */
    eax = RD32((uint32_t)(ebp + 0xffffffa8u));  /* 0x4aebae: mov eax, dword ptr [ebp - 0x58] */
    WR32((uint32_t)(ebp + 0xffffffccu), eax);  /* 0x4aebb1: mov dword ptr [ebp - 0x34], eax */
    ecx = RD32((uint32_t)(ebp + 0xffffff98u));  /* 0x4aebb4: mov ecx, dword ptr [ebp - 0x68] */
    WR32((uint32_t)(ebp + 0xffffffe4u), ecx);  /* 0x4aebb7: mov dword ptr [ebp - 0x1c], ecx */
    goto L_4aebce;  /* 0x4aebba: jmp 0x4aebce */
L_4aebbc:
    edx = RD32((uint32_t)(ebp + 0xffffffccu));  /* 0x4aebbc: mov edx, dword ptr [ebp - 0x34] */
    { uint32_t a_ = edx, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4aebbf: add edx, 1 */
    WR32((uint32_t)(ebp + 0xffffffccu), edx);  /* 0x4aebc2: mov dword ptr [ebp - 0x34], edx */
    eax = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4aebc5: mov eax, dword ptr [ebp - 0x1c] */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4aebc8: add eax, 1 */
    WR32((uint32_t)(ebp + 0xffffffe4u), eax);  /* 0x4aebcb: mov dword ptr [ebp - 0x1c], eax */
L_4aebce:
    ecx = RD32((uint32_t)(ebp + 0xffffffccu));  /* 0x4aebce: mov ecx, dword ptr [ebp - 0x34] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(ebp + 0xffffffc4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4aebd1: cmp ecx, dword ptr [ebp - 0x3c] */
    if ((!zf && sf == of)) goto L_4aec2a;  /* 0x4aebd4: jg 0x4aec2a */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff0u)))) & 0xffffffffu;  /* 0x4aebd6: movsx edx, word ptr [ebp - 0x10] */
    eax = RD32((uint32_t)(ebp + 0xffffffc8u));  /* 0x4aebda: mov eax, dword ptr [ebp - 0x38] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(edx); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4aebdd: imul eax, edx */
    ecx = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x4aebe0: mov ecx, dword ptr [ebp - 0x14] */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4aebe3: add ecx, eax */
    edx = RD32((uint32_t)(ebp + 0xffffffccu));  /* 0x4aebe5: mov edx, dword ptr [ebp - 0x34] */
    eax = (eax & 0xffffff00u) | ((RD8((uint32_t)(ecx + edx))) & 0xffu);  /* 0x4aebe8: mov al, byte ptr [ecx + edx] */
    WR8((uint32_t)(ebp + 0xfffffffcu), (eax & 0xffu));  /* 0x4aebeb: mov byte ptr [ebp - 4], al */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4aebee: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0xffu, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x4aebf1: and ecx, 0xff */
    { uint32_t a_ = ecx, b_ = ecx, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4aebf7: test ecx, ecx */
    if (zf) goto L_4aec28;  /* 0x4aebf9: je 0x4aec28 */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4aebfb: movsx edx, word ptr [ebp - 8] */
    eax = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x4aebff: mov eax, dword ptr [ebp - 0x30] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(edx); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4aec02: imul eax, edx */
    ecx = RD32((uint32_t)(ebp + 0xffffffb0u));  /* 0x4aec05: mov ecx, dword ptr [ebp - 0x50] */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4aec08: add ecx, eax */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(ebp + 0xffffffe4u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4aec0a: add ecx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(ebp + 0xffffffc0u), ecx);  /* 0x4aec0d: mov dword ptr [ebp - 0x40], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffc0u));  /* 0x4aec10: mov edx, dword ptr [ebp - 0x40] */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4aec13: xor eax, eax */
    eax = (eax & 0xffffff00u) | ((RD8((uint32_t)(edx))) & 0xffu);  /* 0x4aec15: mov al, byte ptr [edx] */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4aec17: test eax, eax */
    if (zf) goto L_4aec28;  /* 0x4aec19: je 0x4aec28 */
    ecx = RD32((uint32_t)(ebp + 0xffffffc0u));  /* 0x4aec1b: mov ecx, dword ptr [ebp - 0x40] */
    edx = (edx & 0xffffff00u) | ((RD8((uint32_t)(ecx))) & 0xffu);  /* 0x4aec1e: mov dl, byte ptr [ecx] */
    { uint32_t a_ = (edx & 0xffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 8); edx = (edx & 0xffffff00u) | ((r_) & 0xffu); }  /* 0x4aec20: add dl, 1 */
    eax = RD32((uint32_t)(ebp + 0xffffffc0u));  /* 0x4aec23: mov eax, dword ptr [ebp - 0x40] */
    WR8((uint32_t)(eax), (edx & 0xffu));  /* 0x4aec26: mov byte ptr [eax], dl */
L_4aec28:
    goto L_4aebbc;  /* 0x4aec28: jmp 0x4aebbc */
L_4aec2a:
    goto L_4aeb90;  /* 0x4aec2a: jmp 0x4aeb90 */
L_4aec2f:
    esp = ebp;  /* 0x4aec2f: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4aec31: pop ebp */
    esp += 8u; goto done;  /* 0x4aec32: ret 4 */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4b0f9f (324 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4b0f9f_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4b0f9f: push ebp */
    ebp = esp;  /* 0x4b0fa0: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x10u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4b0fa2: sub esp, 0x10 */
    esp -= 4u; WR32(esp, esi);  /* 0x4b0fa5: push esi */
    esp -= 4u; WR32(esp, edi);  /* 0x4b0fa6: push edi */
    WR32((uint32_t)(ebp + 0xfffffff0u), ecx);  /* 0x4b0fa7: mov dword ptr [ebp - 0x10], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4b0faa: mov eax, dword ptr [ebp - 0x10] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x1eu)))) & 0xffffffffu;  /* 0x4b0fad: movsx ecx, word ptr [eax + 0x1e] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4b0fb1: imul ecx, ecx, 0x8d */
    edx = RD32((uint32_t)(ecx + 0x5bb5e5u));  /* 0x4b0fb7: mov edx, dword ptr [ecx + 0x5bb5e5] */
    WR32((uint32_t)(ebp + 0xfffffff4u), edx);  /* 0x4b0fbd: mov dword ptr [ebp - 0xc], edx */
    WR16((uint32_t)(ebp + 0xfffffffcu), 0x0u);  /* 0x4b0fc0: mov word ptr [ebp - 4], 0 */
    goto L_4b0fd4;  /* 0x4b0fc6: jmp 0x4b0fd4 */
L_4b0fc8:
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffffcu))) & 0xffffu);  /* 0x4b0fc8: mov ax, word ptr [ebp - 4] */
    { uint32_t a_ = (eax & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); eax = (eax & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4b0fcc: add ax, 1 */
    WR16((uint32_t)(ebp + 0xfffffffcu), (eax & 0xffffu));  /* 0x4b0fd0: mov word ptr [ebp - 4], ax */
L_4b0fd4:
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4b0fd4: movsx ecx, word ptr [ebp - 4] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b0fd8: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x21u)))) & 0xffffffffu;  /* 0x4b0fdb: movsx eax, word ptr [edx + 0x21] */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4b0fdf: cmp ecx, eax */
    if ((sf == of)) goto L_4b102d;  /* 0x4b0fe1: jge 0x4b102d */
    WR16((uint32_t)(ebp + 0xfffffff8u), 0x0u);  /* 0x4b0fe3: mov word ptr [ebp - 8], 0 */
    goto L_4b0ff7;  /* 0x4b0fe9: jmp 0x4b0ff7 */
L_4b0feb:
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffff8u))) & 0xffffu);  /* 0x4b0feb: mov cx, word ptr [ebp - 8] */
    { uint32_t a_ = (ecx & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); ecx = (ecx & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4b0fef: add cx, 1 */
    WR16((uint32_t)(ebp + 0xfffffff8u), (ecx & 0xffffu));  /* 0x4b0ff3: mov word ptr [ebp - 8], cx */
L_4b0ff7:
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4b0ff7: movsx edx, word ptr [ebp - 8] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b0ffb: mov eax, dword ptr [ebp - 0xc] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x23u)))) & 0xffffffffu;  /* 0x4b0ffe: movsx ecx, word ptr [eax + 0x23] */
    { uint32_t a_ = edx, b_ = ecx, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4b1002: cmp edx, ecx */
    if ((sf == of)) goto L_4b102b;  /* 0x4b1004: jge 0x4b102b */
    ecx = 0xbu;  /* 0x4b1006: mov ecx, 0xb */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4b100b: xor eax, eax */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4b100d: movsx edx, word ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x1e4u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4b1011: imul edx, edx, 0x1e4 */
    esi = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4b1017: mov esi, dword ptr [ebp - 0x10] */
    edi = (uint32_t)(esi + edx + 0x43u);  /* 0x4b101a: lea edi, [esi + edx + 0x43] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4b101e: movsx edx, word ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x2cu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4b1022: imul edx, edx, 0x2c */
    { uint32_t a_ = edi, b_ = edx, r_; FL41_ADD(a_, b_, 0u, r_, 32); edi = r_; }  /* 0x4b1025: add edi, edx */
    /* 0x4b1027: rep stosd dword ptr es:[edi], eax */
    while (ecx != 0u) {
    WR32(edi, eax);
    edi += 4u;
    ecx -= 1u;
    }
    goto L_4b0feb;  /* 0x4b1029: jmp 0x4b0feb */
L_4b102b:
    goto L_4b0fc8;  /* 0x4b102b: jmp 0x4b0fc8 */
L_4b102d:
    WR16((uint32_t)(ebp + 0xfffffffcu), 0x0u);  /* 0x4b102d: mov word ptr [ebp - 4], 0 */
    goto L_4b1041;  /* 0x4b1033: jmp 0x4b1041 */
L_4b1035:
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffffcu))) & 0xffffu);  /* 0x4b1035: mov ax, word ptr [ebp - 4] */
    { uint32_t a_ = (eax & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); eax = (eax & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4b1039: add ax, 1 */
    WR16((uint32_t)(ebp + 0xfffffffcu), (eax & 0xffffu));  /* 0x4b103d: mov word ptr [ebp - 4], ax */
L_4b1041:
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4b1041: movsx ecx, word ptr [ebp - 4] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b1045: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x21u)))) & 0xffffffffu;  /* 0x4b1048: movsx eax, word ptr [edx + 0x21] */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4b104c: cmp ecx, eax */
    if ((sf == of)) goto L_4b10dd;  /* 0x4b104e: jge 0x4b10dd */
    WR16((uint32_t)(ebp + 0xfffffff8u), 0x0u);  /* 0x4b1054: mov word ptr [ebp - 8], 0 */
    goto L_4b1068;  /* 0x4b105a: jmp 0x4b1068 */
L_4b105c:
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffff8u))) & 0xffffu);  /* 0x4b105c: mov cx, word ptr [ebp - 8] */
    { uint32_t a_ = (ecx & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); ecx = (ecx & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4b1060: add cx, 1 */
    WR16((uint32_t)(ebp + 0xfffffff8u), (ecx & 0xffffu));  /* 0x4b1064: mov word ptr [ebp - 8], cx */
L_4b1068:
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4b1068: movsx edx, word ptr [ebp - 8] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b106c: mov eax, dword ptr [ebp - 0xc] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x23u)))) & 0xffffffffu;  /* 0x4b106f: movsx ecx, word ptr [eax + 0x23] */
    { uint32_t a_ = edx, b_ = ecx, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4b1073: cmp edx, ecx */
    if ((sf == of)) goto L_4b10d8;  /* 0x4b1075: jge 0x4b10d8 */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4b1077: movsx edx, word ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x16u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4b107b: imul edx, edx, 0x16 */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b107e: mov eax, dword ptr [ebp - 0xc] */
    ecx = (uint32_t)(eax + edx + 0x2bu);  /* 0x4b1081: lea ecx, [eax + edx + 0x2b] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4b1085: movsx edx, word ptr [ebp - 8] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + edx * 2u)))) & 0xffffffffu;  /* 0x4b1089: movsx eax, word ptr [ecx + edx*2] */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4b108d: test eax, eax */
    if (zf) goto L_4b10d6;  /* 0x4b108f: je 0x4b10d6 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4b1091: movsx ecx, word ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x16u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4b1095: imul ecx, ecx, 0x16 */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b1098: mov edx, dword ptr [ebp - 0xc] */
    eax = (uint32_t)(edx + ecx + 0x2bu);  /* 0x4b109b: lea eax, [edx + ecx + 0x2b] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4b109f: movsx ecx, word ptr [ebp - 8] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4b10a3: movsx edx, word ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x1e4u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4b10a7: imul edx, edx, 0x1e4 */
    esi = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4b10ad: mov esi, dword ptr [ebp - 0x10] */
    edx = (uint32_t)(esi + edx + 0x43u);  /* 0x4b10b0: lea edx, [esi + edx + 0x43] */
    esi = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4b10b4: movsx esi, word ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(esi) * (int32_t)(0x2cu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); esi = r_; }  /* 0x4b10b8: imul esi, esi, 0x2c */
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(eax + ecx * 2u))) & 0xffffu);  /* 0x4b10bb: mov ax, word ptr [eax + ecx*2] */
    WR16((uint32_t)(edx + esi + 0x18u), (eax & 0xffffu));  /* 0x4b10bf: mov word ptr [edx + esi + 0x18], ax */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffff8u))) & 0xffffu);  /* 0x4b10c4: mov cx, word ptr [ebp - 8] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4b10c8: push ecx */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffffcu))) & 0xffffu);  /* 0x4b10c9: mov dx, word ptr [ebp - 4] */
    esp -= 4u; WR32(esp, edx);  /* 0x4b10cd: push edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4b10ce: mov ecx, dword ptr [ebp - 0x10] */
    esp -= 4u; WR32(esp, 0x4b10d6u); FL41_CALL(0x4b10e3u); esp += 8u; esp += 4u;  /* 0x4b10d1: call 0x4b10e3 */
L_4b10d6:
    goto L_4b105c;  /* 0x4b10d6: jmp 0x4b105c */
L_4b10d8:
    goto L_4b1035;  /* 0x4b10d8: jmp 0x4b1035 */
L_4b10dd:
    edi = RD32(esp); esp += 4u;  /* 0x4b10dd: pop edi */
    esi = RD32(esp); esp += 4u;  /* 0x4b10de: pop esi */
    esp = ebp;  /* 0x4b10df: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4b10e1: pop ebp */
    esp += 4u; goto done;  /* 0x4b10e2: ret  */
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

/* GAME.EXE 0x4b4676 (669 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4b4676_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4b4676: push ebp */
    ebp = esp;  /* 0x4b4677: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0xcu, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4b4679: sub esp, 0xc */
    esp -= 4u; WR32(esp, esi);  /* 0x4b467c: push esi */
    WR32((uint32_t)(ebp + 0xfffffff4u), ecx);  /* 0x4b467d: mov dword ptr [ebp - 0xc], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4680: mov eax, dword ptr [ebp - 0xc] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x72au)))) & 0xffffffffu;  /* 0x4b4683: movsx ecx, word ptr [eax + 0x72a] */
    { uint32_t a_ = ecx, b_ = 0xffffffffu, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4b468a: cmp ecx, -1 */
    if (!zf) goto L_4b4696;  /* 0x4b468d: jne 0x4b4696 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4b468f: xor eax, eax */
    goto L_4b490e;  /* 0x4b4691: jmp 0x4b490e */
L_4b4696:
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x591a22u)))) & 0xffffffffu;  /* 0x4b4696: movsx edx, word ptr [0x591a22] */
    { uint32_t a_ = edx, b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4b469d: sub edx, 1 */
    WR16((uint32_t)(ebp + 0xfffffffcu), (edx & 0xffffu));  /* 0x4b46a0: mov word ptr [ebp - 4], dx */
    goto L_4b46b2;  /* 0x4b46a4: jmp 0x4b46b2 */
L_4b46a6:
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffffcu))) & 0xffffu);  /* 0x4b46a6: mov ax, word ptr [ebp - 4] */
    { uint32_t a_ = (eax & 0xffffu), b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 16); eax = (eax & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4b46aa: sub ax, 1 */
    WR16((uint32_t)(ebp + 0xfffffffcu), (eax & 0xffffu));  /* 0x4b46ae: mov word ptr [ebp - 4], ax */
L_4b46b2:
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4b46b2: movsx ecx, word ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = ecx, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4b46b6: test ecx, ecx */
    if ((sf != of)) goto L_4b48fc;  /* 0x4b46b8: jl 0x4b48fc */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b46be: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x72au)))) & 0xffffffffu;  /* 0x4b46c1: movsx eax, word ptr [edx + 0x72a] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0xcu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4b46c8: imul eax, eax, 0xc */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4b46cb: movsx ecx, word ptr [ebp - 4] */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(eax + ecx * 2u + 0x5919feu))) & 0xffffu);  /* 0x4b46cf: mov dx, word ptr [eax + ecx*2 + 0x5919fe] */
    WR16((uint32_t)(ebp + 0xfffffff8u), (edx & 0xffffu));  /* 0x4b46d7: mov word ptr [ebp - 8], dx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4b46db: movsx eax, word ptr [ebp - 8] */
    { uint32_t a_ = eax, b_ = 0xffffffffu, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4b46df: cmp eax, -1 */
    if (zf) goto L_4b48f7;  /* 0x4b46e2: je 0x4b48f7 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b46e8: mov ecx, dword ptr [ebp - 0xc] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0x728u)))) & 0xffffffffu;  /* 0x4b46eb: movsx edx, word ptr [ecx + 0x728] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4b46f2: imul edx, edx, 0x8d */
    eax = RD32((uint32_t)(edx + 0x5bb5e5u));  /* 0x4b46f8: mov eax, dword ptr [edx + 0x5bb5e5] */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(eax + 0x7fau))) & 0xffffu);  /* 0x4b46fe: mov cx, word ptr [eax + 0x7fa] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4b4705: push ecx */
    ecx = 0x5c3a67u;  /* 0x4b4706: mov ecx, 0x5c3a67 */
    esp -= 4u; WR32(esp, 0x4b4710u); FL41_CALL(0x4fb2e3u); esp += 4u; esp += 4u;  /* 0x4b470b: call 0x4fb2e3 */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4710: mov edx, dword ptr [ebp - 0xc] */
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffff8u))) & 0xffffu);  /* 0x4b4713: mov ax, word ptr [ebp - 8] */
    WR16((uint32_t)(edx + 0x71cu), (eax & 0xffffu));  /* 0x4b4717: mov word ptr [edx + 0x71c], ax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b471e: mov ecx, dword ptr [ebp - 0xc] */
    WR16((uint32_t)(ecx + 0x750u), 0x1u);  /* 0x4b4721: mov word ptr [ecx + 0x750], 1 */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b472a: mov edx, dword ptr [ebp - 0xc] */
    WR16((uint32_t)(edx + 0x752u), 0x0u);  /* 0x4b472d: mov word ptr [edx + 0x752], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4736: mov eax, dword ptr [ebp - 0xc] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x72au)))) & 0xffffffffu;  /* 0x4b4739: movsx ecx, word ptr [eax + 0x72a] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0xcu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4b4740: imul ecx, ecx, 0xc */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4b4743: movsx edx, word ptr [ebp - 4] */
    WR16((uint32_t)(ecx + edx * 2u + 0x5919feu), 0xffffu);  /* 0x4b4747: mov word ptr [ecx + edx*2 + 0x5919fe], 0xffff */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4751: mov eax, dword ptr [ebp - 0xc] */
    WR16((uint32_t)(eax + 0x74cu), 0x1u);  /* 0x4b4754: mov word ptr [eax + 0x74c], 1 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b475d: mov ecx, dword ptr [ebp - 0xc] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0x71cu)))) & 0xffffffffu;  /* 0x4b4760: movsx edx, word ptr [ecx + 0x71c] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x120u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4b4767: imul edx, edx, 0x120 */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b476d: mov eax, dword ptr [ebp - 0xc] */
    ecx = (uint32_t)(eax + edx + 0x1cu);  /* 0x4b4770: lea ecx, [eax + edx + 0x1c] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4774: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x72au)))) & 0xffffffffu;  /* 0x4b4777: movsx eax, word ptr [edx + 0x72a] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x60u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4b477e: imul eax, eax, 0x60 */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4b4781: add ecx, eax */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4b4783: movsx edx, word ptr [ebp - 4] */
    { uint32_t a_ = edx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); edx = r_; } }  /* 0x4b4787: shl edx, 4 */
    { uint32_t a_ = ecx, b_ = edx, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4b478a: add ecx, edx */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b478c: mov eax, dword ptr [ebp - 0xc] */
    { uint32_t a_ = eax, b_ = 0x72cu, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b478f: add eax, 0x72c */
    edx = RD32((uint32_t)(ecx));  /* 0x4b4794: mov edx, dword ptr [ecx] */
    WR32((uint32_t)(eax), edx);  /* 0x4b4796: mov dword ptr [eax], edx */
    edx = RD32((uint32_t)(ecx + 0x4u));  /* 0x4b4798: mov edx, dword ptr [ecx + 4] */
    WR32((uint32_t)(eax + 0x4u), edx);  /* 0x4b479b: mov dword ptr [eax + 4], edx */
    edx = RD32((uint32_t)(ecx + 0x8u));  /* 0x4b479e: mov edx, dword ptr [ecx + 8] */
    WR32((uint32_t)(eax + 0x8u), edx);  /* 0x4b47a1: mov dword ptr [eax + 8], edx */
    ecx = RD32((uint32_t)(ecx + 0xcu));  /* 0x4b47a4: mov ecx, dword ptr [ecx + 0xc] */
    WR32((uint32_t)(eax + 0xcu), ecx);  /* 0x4b47a7: mov dword ptr [eax + 0xc], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b47aa: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x728u)))) & 0xffffffffu;  /* 0x4b47ad: movsx eax, word ptr [edx + 0x728] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4b47b4: imul eax, eax, 0x8d */
    ecx = RD32((uint32_t)(eax + 0x5bb5e5u));  /* 0x4b47ba: mov ecx, dword ptr [eax + 0x5bb5e5] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b47c0: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x71cu)))) & 0xffffffffu;  /* 0x4b47c3: movsx eax, word ptr [edx + 0x71c] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x120u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4b47ca: imul eax, eax, 0x120 */
    ecx = (uint32_t)(ecx + eax + 0x119u);  /* 0x4b47d0: lea ecx, [ecx + eax + 0x119] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b47d7: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x72au)))) & 0xffffffffu;  /* 0x4b47da: movsx eax, word ptr [edx + 0x72a] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x60u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4b47e1: imul eax, eax, 0x60 */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4b47e4: add ecx, eax */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4b47e6: movsx edx, word ptr [ebp - 4] */
    { uint32_t a_ = edx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); edx = r_; } }  /* 0x4b47ea: shl edx, 4 */
    { uint32_t a_ = ecx, b_ = edx, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4b47ed: add ecx, edx */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b47ef: mov eax, dword ptr [ebp - 0xc] */
    { uint32_t a_ = eax, b_ = 0x73cu, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b47f2: add eax, 0x73c */
    edx = RD32((uint32_t)(ecx));  /* 0x4b47f7: mov edx, dword ptr [ecx] */
    WR32((uint32_t)(eax), edx);  /* 0x4b47f9: mov dword ptr [eax], edx */
    edx = RD32((uint32_t)(ecx + 0x4u));  /* 0x4b47fb: mov edx, dword ptr [ecx + 4] */
    WR32((uint32_t)(eax + 0x4u), edx);  /* 0x4b47fe: mov dword ptr [eax + 4], edx */
    edx = RD32((uint32_t)(ecx + 0x8u));  /* 0x4b4801: mov edx, dword ptr [ecx + 8] */
    WR32((uint32_t)(eax + 0x8u), edx);  /* 0x4b4804: mov dword ptr [eax + 8], edx */
    ecx = RD32((uint32_t)(ecx + 0xcu));  /* 0x4b4807: mov ecx, dword ptr [ecx + 0xc] */
    WR32((uint32_t)(eax + 0xcu), ecx);  /* 0x4b480a: mov dword ptr [eax + 0xc], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b480d: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x728u)))) & 0xffffffffu;  /* 0x4b4810: movsx eax, word ptr [edx + 0x728] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4b4817: imul eax, eax, 0x8d */
    ecx = RD32((uint32_t)(eax + 0x5bb5e5u));  /* 0x4b481d: mov ecx, dword ptr [eax + 0x5bb5e5] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4823: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x71cu)))) & 0xffffffffu;  /* 0x4b4826: movsx eax, word ptr [edx + 0x71c] */
    { uint32_t a_ = eax, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); eax = r_; } }  /* 0x4b482d: shl eax, 4 */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4830: mov edx, dword ptr [ebp - 0xc] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x728u)))) & 0xffffffffu;  /* 0x4b4833: movsx edx, word ptr [edx + 0x728] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4b483a: imul edx, edx, 0x8d */
    edx = RD32((uint32_t)(edx + 0x5bb5e5u));  /* 0x4b4840: mov edx, dword ptr [edx + 0x5bb5e5] */
    esi = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4846: mov esi, dword ptr [ebp - 0xc] */
    esi = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(esi + 0x71cu)))) & 0xffffffffu;  /* 0x4b4849: movsx esi, word ptr [esi + 0x71c] */
    { uint32_t a_ = esi, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); esi = r_; } }  /* 0x4b4850: shl esi, 4 */
    eax = RD32((uint32_t)(ecx + eax + 0x91u));  /* 0x4b4853: mov eax, dword ptr [ecx + eax + 0x91] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(edx + esi + 0x89u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b485a: sub eax, dword ptr [edx + esi + 0x89] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4861: mov ecx, dword ptr [ebp - 0xc] */
    WR16((uint32_t)(ecx + 0x71eu), (eax & 0xffffu));  /* 0x4b4864: mov word ptr [ecx + 0x71e], ax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b486b: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x728u)))) & 0xffffffffu;  /* 0x4b486e: movsx eax, word ptr [edx + 0x728] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4b4875: imul eax, eax, 0x8d */
    ecx = RD32((uint32_t)(eax + 0x5bb5e5u));  /* 0x4b487b: mov ecx, dword ptr [eax + 0x5bb5e5] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4881: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x71cu)))) & 0xffffffffu;  /* 0x4b4884: movsx eax, word ptr [edx + 0x71c] */
    { uint32_t a_ = eax, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); eax = r_; } }  /* 0x4b488b: shl eax, 4 */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b488e: mov edx, dword ptr [ebp - 0xc] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x728u)))) & 0xffffffffu;  /* 0x4b4891: movsx edx, word ptr [edx + 0x728] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4b4898: imul edx, edx, 0x8d */
    edx = RD32((uint32_t)(edx + 0x5bb5e5u));  /* 0x4b489e: mov edx, dword ptr [edx + 0x5bb5e5] */
    esi = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b48a4: mov esi, dword ptr [ebp - 0xc] */
    esi = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(esi + 0x71cu)))) & 0xffffffffu;  /* 0x4b48a7: movsx esi, word ptr [esi + 0x71c] */
    { uint32_t a_ = esi, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); esi = r_; } }  /* 0x4b48ae: shl esi, 4 */
    eax = RD32((uint32_t)(ecx + eax + 0x95u));  /* 0x4b48b1: mov eax, dword ptr [ecx + eax + 0x95] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(edx + esi + 0x8du)), r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b48b8: sub eax, dword ptr [edx + esi + 0x8d] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b48bf: mov ecx, dword ptr [ebp - 0xc] */
    WR16((uint32_t)(ecx + 0x722u), (eax & 0xffffu));  /* 0x4b48c2: mov word ptr [ecx + 0x722], ax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b48c9: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x71eu)))) & 0xffffffffu;  /* 0x4b48cc: movsx eax, word ptr [edx + 0x71e] */
    { uint32_t a_ = eax, n_ = 0x1u, r_; if (n_ != 0u) { FL41_SAR(r_, a_, n_, 32); eax = r_; } }  /* 0x4b48d3: sar eax, 1 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b48d5: mov ecx, dword ptr [ebp - 0xc] */
    WR16((uint32_t)(ecx + 0x720u), (eax & 0xffffu));  /* 0x4b48d8: mov word ptr [ecx + 0x720], ax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b48df: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x722u)))) & 0xffffffffu;  /* 0x4b48e2: movsx eax, word ptr [edx + 0x722] */
    { uint32_t a_ = eax, n_ = 0x1u, r_; if (n_ != 0u) { FL41_SAR(r_, a_, n_, 32); eax = r_; } }  /* 0x4b48e9: sar eax, 1 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b48eb: mov ecx, dword ptr [ebp - 0xc] */
    WR16((uint32_t)(ecx + 0x724u), (eax & 0xffffu));  /* 0x4b48ee: mov word ptr [ecx + 0x724], ax */
    goto L_4b48fc;  /* 0x4b48f5: jmp 0x4b48fc */
L_4b48f7:
    goto L_4b46a6;  /* 0x4b48f7: jmp 0x4b46a6 */
L_4b48fc:
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4b48fc: movsx edx, word ptr [ebp - 8] */
    { uint32_t a_ = edx, b_ = 0xffffffffu, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4b4900: cmp edx, -1 */
    if (!zf) goto L_4b4909;  /* 0x4b4903: jne 0x4b4909 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4b4905: xor eax, eax */
    goto L_4b490e;  /* 0x4b4907: jmp 0x4b490e */
L_4b4909:
    eax = 0x1u;  /* 0x4b4909: mov eax, 1 */
L_4b490e:
    esi = RD32(esp); esp += 4u;  /* 0x4b490e: pop esi */
    esp = ebp;  /* 0x4b490f: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4b4911: pop ebp */
    esp += 4u; goto done;  /* 0x4b4912: ret  */
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

/* GAME.EXE 0x4be1dd (233 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4be1dd_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4be1dd: push ebp */
    ebp = esp;  /* 0x4be1de: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x10u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4be1e0: sub esp, 0x10 */
    WR32((uint32_t)(ebp + 0xfffffff0u), ecx);  /* 0x4be1e3: mov dword ptr [ebp - 0x10], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4be1e6: mov eax, dword ptr [ebp - 0x10] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x4cu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4be1e9: cmp dword ptr [eax + 0x4c], 0 */
    if (!zf) goto L_4be1f4;  /* 0x4be1ed: jne 0x4be1f4 */
    goto L_4be2c0;  /* 0x4be1ef: jmp 0x4be2c0 */
L_4be1f4:
    { uint32_t a_ = RD32((uint32_t)(ebp + 0x8u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4be1f4: cmp dword ptr [ebp + 8], 0 */
    if (!zf) goto L_4be1ff;  /* 0x4be1f8: jne 0x4be1ff */
    goto L_4be2c0;  /* 0x4be1fa: jmp 0x4be2c0 */
L_4be1ff:
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4be1ff: mov ecx, dword ptr [ebp + 8] */
    edx = RD32((uint32_t)(ecx + 0x150u));  /* 0x4be202: mov edx, dword ptr [ecx + 0x150] */
    WR32((uint32_t)(ebp + 0xfffffff4u), edx);  /* 0x4be208: mov dword ptr [ebp - 0xc], edx */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4be20b: mov eax, dword ptr [ebp + 8] */
    ecx = RD32((uint32_t)(eax + 0x14cu));  /* 0x4be20e: mov ecx, dword ptr [eax + 0x14c] */
    WR32((uint32_t)(ebp + 0xfffffff8u), ecx);  /* 0x4be214: mov dword ptr [ebp - 8], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4be217: mov edx, dword ptr [ebp - 0x10] */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4be21a: mov eax, dword ptr [ebp + 8] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(edx + 0x4cu)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4be21d: cmp eax, dword ptr [edx + 0x4c] */
    if (!zf) goto L_4be24c;  /* 0x4be220: jne 0x4be24c */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffff4u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4be222: cmp dword ptr [ebp - 0xc], 0 */
    if (zf) goto L_4be240;  /* 0x4be226: je 0x4be240 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4be228: mov ecx, dword ptr [ebp - 0x10] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4be22b: mov edx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x4cu), edx);  /* 0x4be22e: mov dword ptr [ecx + 0x4c], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4be231: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0x14cu), 0x0u);  /* 0x4be234: mov dword ptr [eax + 0x14c], 0 */
    goto L_4be24a;  /* 0x4be23e: jmp 0x4be24a */
L_4be240:
    ecx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4be240: mov ecx, dword ptr [ebp - 0x10] */
    WR32((uint32_t)(ecx + 0x4cu), 0x0u);  /* 0x4be243: mov dword ptr [ecx + 0x4c], 0 */
L_4be24a:
    goto L_4be285;  /* 0x4be24a: jmp 0x4be285 */
L_4be24c:
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffff4u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4be24c: cmp dword ptr [ebp - 0xc], 0 */
    if (zf) goto L_4be272;  /* 0x4be250: je 0x4be272 */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffff8u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4be252: cmp dword ptr [ebp - 8], 0 */
    if (zf) goto L_4be272;  /* 0x4be256: je 0x4be272 */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4be258: mov edx, dword ptr [ebp - 8] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4be25b: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(edx + 0x150u), eax);  /* 0x4be25e: mov dword ptr [edx + 0x150], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4be264: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4be267: mov edx, dword ptr [ebp - 8] */
    WR32((uint32_t)(ecx + 0x14cu), edx);  /* 0x4be26a: mov dword ptr [ecx + 0x14c], edx */
    goto L_4be285;  /* 0x4be270: jmp 0x4be285 */
L_4be272:
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffff8u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4be272: cmp dword ptr [ebp - 8], 0 */
    if (zf) goto L_4be285;  /* 0x4be276: je 0x4be285 */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4be278: mov eax, dword ptr [ebp - 8] */
    WR32((uint32_t)(eax + 0x150u), 0x0u);  /* 0x4be27b: mov dword ptr [eax + 0x150], 0 */
L_4be285:
    ecx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4be285: mov ecx, dword ptr [ebp - 0x10] */
    { uint32_t a_ = RD32((uint32_t)(ecx + 0x4cu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4be288: cmp dword ptr [ecx + 0x4c], 0 */
    if (zf) goto L_4be2b4;  /* 0x4be28c: je 0x4be2b4 */
    edx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4be28e: mov edx, dword ptr [ebp - 0x10] */
    eax = RD32((uint32_t)(edx + 0x4cu));  /* 0x4be291: mov eax, dword ptr [edx + 0x4c] */
    WR32((uint32_t)(ebp + 0xfffffffcu), eax);  /* 0x4be294: mov dword ptr [ebp - 4], eax */
L_4be297:
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffffcu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4be297: cmp dword ptr [ebp - 4], 0 */
    if (zf) goto L_4be2b4;  /* 0x4be29b: je 0x4be2b4 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4be29d: mov ecx, dword ptr [ebp - 0x10] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4be2a0: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x50u), edx);  /* 0x4be2a3: mov dword ptr [ecx + 0x50], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4be2a6: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x150u));  /* 0x4be2a9: mov ecx, dword ptr [eax + 0x150] */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4be2af: mov dword ptr [ebp - 4], ecx */
    goto L_4be297;  /* 0x4be2b2: jmp 0x4be297 */
L_4be2b4:
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4be2b4: mov edx, dword ptr [ebp + 8] */
    esp -= 4u; WR32(esp, edx);  /* 0x4be2b7: push edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4be2b8: mov ecx, dword ptr [ebp - 0x10] */
    esp -= 4u; WR32(esp, 0x4be2c0u); FL41_CALL(0x4be2c6u); esp += 4u; esp += 4u;  /* 0x4be2bb: call 0x4be2c6 */
L_4be2c0:
    esp = ebp;  /* 0x4be2c0: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4be2c2: pop ebp */
    esp += 8u; goto done;  /* 0x4be2c3: ret 4 */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4bf1f0 (167 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4bf1f0_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4bf1f0: push ebp */
    ebp = esp;  /* 0x4bf1f1: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x10u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4bf1f3: sub esp, 0x10 */
    WR32((uint32_t)(ebp + 0xfffffff0u), ecx);  /* 0x4bf1f6: mov dword ptr [ebp - 0x10], ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), 0x0u);  /* 0x4bf1f9: mov dword ptr [ebp - 4], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4bf200: mov ecx, dword ptr [ebp - 0x10] */
    esp -= 4u; WR32(esp, 0x4bf208u); FL41_CALL(0x4bf38cu); esp += 4u;  /* 0x4bf203: call 0x4bf38c */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0x8u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4bf208: cmp dword ptr [ebp + 8], 0 */
    if (!zf) goto L_4bf220;  /* 0x4bf20c: jne 0x4bf220 */
    eax = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4bf20e: mov eax, dword ptr [ebp - 0x10] */
    WR32((uint32_t)(eax + 0x2c0u), 0xfffffffdu);  /* 0x4bf211: mov dword ptr [eax + 0x2c0], 0xfffffffd */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4bf21b: mov eax, dword ptr [ebp - 4] */
    goto L_4bf291;  /* 0x4bf21e: jmp 0x4bf291 */
L_4bf220:
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4bf220: mov ecx, dword ptr [ebp + 0xc] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4bf223: push ecx */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4bf224: mov edx, dword ptr [ebp + 8] */
    esp -= 4u; WR32(esp, edx);  /* 0x4bf227: push edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4bf228: mov ecx, dword ptr [ebp - 0x10] */
    esp -= 4u; WR32(esp, 0x4bf230u); FL41_CALL(0x4bf19au); esp += 8u; esp += 4u;  /* 0x4bf22b: call 0x4bf19a */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4bf230: test eax, eax */
    if (zf) goto L_4bf28e;  /* 0x4bf232: je 0x4bf28e */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x639895u)))) & 0xffffffffu;  /* 0x4bf234: movsx eax, word ptr [0x639895] */
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4bf23b: mov ecx, dword ptr [ebp + 8] */
    edx = RD32((uint32_t)(ecx));  /* 0x4bf23e: mov edx, dword ptr [ecx] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(eax); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4bf240: imul edx, eax */
    WR32((uint32_t)(ebp + 0xfffffff4u), edx);  /* 0x4bf243: mov dword ptr [ebp - 0xc], edx */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4bf246: mov eax, dword ptr [ebp + 8] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4bf249: mov ecx, dword ptr [ebp - 0xc] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(RD32((uint32_t)(eax + 0x4u))); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4bf24c: imul ecx, dword ptr [eax + 4] */
    WR32((uint32_t)(ebp + 0xfffffff8u), ecx);  /* 0x4bf250: mov dword ptr [ebp - 8], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4bf253: mov edx, dword ptr [ebp - 8] */
    esp -= 4u; WR32(esp, edx);  /* 0x4bf256: push edx */
    eax = (uint32_t)(ebp + 0xfffffffcu);  /* 0x4bf257: lea eax, [ebp - 4] */
    esp -= 4u; WR32(esp, eax);  /* 0x4bf25a: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4bf25b: mov ecx, dword ptr [ebp - 0x10] */
    esp -= 4u; WR32(esp, 0x4bf263u); FL41_CALL(0x4bf542u); esp += 8u; esp += 4u;  /* 0x4bf25e: call 0x4bf542 */
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4bf263: mov ecx, dword ptr [ebp + 8] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4bf266: push ecx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4bf267: mov ecx, dword ptr [ebp - 0x10] */
    esp -= 4u; WR32(esp, 0x4bf26fu); FL41_CALL(0x4befc8u); esp += 4u; esp += 4u;  /* 0x4bf26a: call 0x4befc8 */
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4bf26f: push 0 */
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4bf271: push 0 */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4bf273: mov edx, dword ptr [ebp + 8] */
    eax = RD32((uint32_t)(edx + 0x4u));  /* 0x4bf276: mov eax, dword ptr [edx + 4] */
    esp -= 4u; WR32(esp, eax);  /* 0x4bf279: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4bf27a: mov ecx, dword ptr [ebp - 0xc] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4bf27d: push ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4bf27e: mov edx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, edx);  /* 0x4bf281: push edx */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4bf282: mov eax, dword ptr [ebp + 8] */
    esp -= 4u; WR32(esp, eax);  /* 0x4bf285: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4bf286: mov ecx, dword ptr [ebp - 0x10] */
    esp -= 4u; WR32(esp, 0x4bf28eu); FL41_CALL(0x4bf098u); esp += 24u; esp += 4u;  /* 0x4bf289: call 0x4bf098 */
L_4bf28e:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4bf28e: mov eax, dword ptr [ebp - 4] */
L_4bf291:
    esp = ebp;  /* 0x4bf291: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4bf293: pop ebp */
    esp += 12u; goto done;  /* 0x4bf294: ret 8 */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4c0f70 (1066 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4c0f70_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4c0f70: push ebp */
    ebp = esp;  /* 0x4c0f71: mov ebp, esp */
    esp -= 4u; WR32(esp, 0xffffffffu);  /* 0x4c0f73: push -1 */
    esp -= 4u; WR32(esp, 0x5287c8u);  /* 0x4c0f75: push 0x5287c8 */
    eax = RD32((uint32_t)(FL41_TIB));  /* 0x4c0f7a: mov eax, dword ptr fs:[0] */
    esp -= 4u; WR32(esp, eax);  /* 0x4c0f80: push eax */
    WR32((uint32_t)(FL41_TIB), esp);  /* 0x4c0f81: mov dword ptr fs:[0], esp */
    { uint32_t a_ = esp, b_ = 0x10u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4c0f88: sub esp, 0x10 */
    esp -= 4u; WR32(esp, edi);  /* 0x4c0f8b: push edi */
    WR32((uint32_t)(ebp + 0xffffffe4u), ecx);  /* 0x4c0f8c: mov dword ptr [ebp - 0x1c], ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), 0x0u);  /* 0x4c0f8f: mov dword ptr [ebp - 4], 0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c0f96: mov ecx, dword ptr [ebp - 0x1c] */
    { uint32_t a_ = ecx, b_ = 0x38ccu, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4c0f99: add ecx, 0x38cc */
    esp -= 4u; WR32(esp, 0x4c0fa4u); FL41_CALL(0x43ef10u); esp += 4u;  /* 0x4c0f9f: call 0x43ef10 */
    WR8((uint32_t)(ebp + 0xfffffffcu), 0x1u);  /* 0x4c0fa4: mov byte ptr [ebp - 4], 1 */
    eax = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c0fa8: mov eax, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(eax), 0x52e230u);  /* 0x4c0fab: mov dword ptr [eax], 0x52e230 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c0fb1: mov ecx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(ecx + 0x4u), 0x0u);  /* 0x4c0fb4: mov dword ptr [ecx + 4], 0 */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c0fbb: mov edx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(edx + 0x8u), 0x0u);  /* 0x4c0fbe: mov dword ptr [edx + 8], 0 */
    eax = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c0fc5: mov eax, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(eax + 0xcu), 0x0u);  /* 0x4c0fc8: mov dword ptr [eax + 0xc], 0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c0fcf: mov ecx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(ecx + 0x46u), 0x0u);  /* 0x4c0fd2: mov dword ptr [ecx + 0x46], 0 */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c0fd9: mov edx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(edx + 0x14u), 0x0u);  /* 0x4c0fdc: mov dword ptr [edx + 0x14], 0 */
    WR16((uint32_t)(ebp + 0xfffffff0u), 0x0u);  /* 0x4c0fe3: mov word ptr [ebp - 0x10], 0 */
    goto L_4c0ff7;  /* 0x4c0fe9: jmp 0x4c0ff7 */
L_4c0feb:
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffff0u))) & 0xffffu);  /* 0x4c0feb: mov ax, word ptr [ebp - 0x10] */
    { uint32_t a_ = (eax & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); eax = (eax & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4c0fef: add ax, 1 */
    WR16((uint32_t)(ebp + 0xfffffff0u), (eax & 0xffffu));  /* 0x4c0ff3: mov word ptr [ebp - 0x10], ax */
L_4c0ff7:
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff0u)))) & 0xffffffffu;  /* 0x4c0ff7: movsx ecx, word ptr [ebp - 0x10] */
    { uint32_t a_ = ecx, b_ = 0x18u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4c0ffb: cmp ecx, 0x18 */
    if ((sf == of)) goto L_4c1014;  /* 0x4c0ffe: jge 0x4c1014 */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff0u)))) & 0xffffffffu;  /* 0x4c1000: movsx edx, word ptr [ebp - 0x10] */
    eax = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1004: mov eax, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(eax + edx * 4u + 0xc72u), 0x0u);  /* 0x4c1007: mov dword ptr [eax + edx*4 + 0xc72], 0 */
    goto L_4c0feb;  /* 0x4c1012: jmp 0x4c0feb */
L_4c1014:
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1014: mov ecx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(ecx + 0xcd2u), 0x0u);  /* 0x4c1017: mov dword ptr [ecx + 0xcd2], 0 */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1021: mov edx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(edx + 0xd1eu), 0x0u);  /* 0x4c1024: mov dword ptr [edx + 0xd1e], 0 */
    eax = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c102e: mov eax, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(eax + 0xd62u), 0x0u);  /* 0x4c1031: mov dword ptr [eax + 0xd62], 0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c103b: mov ecx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(ecx + 0xd76u), 0x0u);  /* 0x4c103e: mov dword ptr [ecx + 0xd76], 0 */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1048: mov edx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(edx + 0xd7au), 0x0u);  /* 0x4c104b: mov dword ptr [edx + 0xd7a], 0 */
    eax = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1055: mov eax, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(eax + 0xd7eu), 0x0u);  /* 0x4c1058: mov dword ptr [eax + 0xd7e], 0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1062: mov ecx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(ecx + 0xd82u), 0x0u);  /* 0x4c1065: mov dword ptr [ecx + 0xd82], 0 */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c106f: mov edx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(edx + 0xd86u), 0x0u);  /* 0x4c1072: mov dword ptr [edx + 0xd86], 0 */
    eax = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c107c: mov eax, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(eax + 0xd6eu), 0x0u);  /* 0x4c107f: mov dword ptr [eax + 0xd6e], 0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1089: mov ecx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(ecx + 0xd72u), 0x0u);  /* 0x4c108c: mov dword ptr [ecx + 0xd72], 0 */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1096: mov edx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(edx + 0xd66u), 0x0u);  /* 0x4c1099: mov dword ptr [edx + 0xd66], 0 */
    eax = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c10a3: mov eax, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(eax + 0xd6au), 0x0u);  /* 0x4c10a6: mov dword ptr [eax + 0xd6a], 0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c10b0: mov ecx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(ecx + 0xd22u), 0x0u);  /* 0x4c10b3: mov dword ptr [ecx + 0xd22], 0 */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c10bd: mov edx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(edx + 0xd5eu), 0x0u);  /* 0x4c10c0: mov dword ptr [edx + 0xd5e], 0 */
    eax = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c10ca: mov eax, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(eax + 0xd36u), 0x0u);  /* 0x4c10cd: mov dword ptr [eax + 0xd36], 0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c10d7: mov ecx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(ecx + 0xd3au), 0x0u);  /* 0x4c10da: mov dword ptr [ecx + 0xd3a], 0 */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c10e4: mov edx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(edx + 0xd56u), 0x0u);  /* 0x4c10e7: mov dword ptr [edx + 0xd56], 0 */
    eax = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c10f1: mov eax, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(eax + 0xd5au), 0x0u);  /* 0x4c10f4: mov dword ptr [eax + 0xd5a], 0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c10fe: mov ecx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(ecx + 0xd26u), 0x0u);  /* 0x4c1101: mov dword ptr [ecx + 0xd26], 0 */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c110b: mov edx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(edx + 0xd2au), 0x0u);  /* 0x4c110e: mov dword ptr [edx + 0xd2a], 0 */
    eax = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1118: mov eax, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(eax + 0xd2eu), 0x0u);  /* 0x4c111b: mov dword ptr [eax + 0xd2e], 0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1125: mov ecx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(ecx + 0xd32u), 0x0u);  /* 0x4c1128: mov dword ptr [ecx + 0xd32], 0 */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1132: mov edx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(edx + 0x38a8u), 0x0u);  /* 0x4c1135: mov dword ptr [edx + 0x38a8], 0 */
    WR16((uint32_t)(ebp + 0xfffffff0u), 0x0u);  /* 0x4c113f: mov word ptr [ebp - 0x10], 0 */
    goto L_4c1153;  /* 0x4c1145: jmp 0x4c1153 */
L_4c1147:
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffff0u))) & 0xffffu);  /* 0x4c1147: mov ax, word ptr [ebp - 0x10] */
    { uint32_t a_ = (eax & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); eax = (eax & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4c114b: add ax, 1 */
    WR16((uint32_t)(ebp + 0xfffffff0u), (eax & 0xffffu));  /* 0x4c114f: mov word ptr [ebp - 0x10], ax */
L_4c1153:
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff0u)))) & 0xffffffffu;  /* 0x4c1153: movsx ecx, word ptr [ebp - 0x10] */
    { uint32_t a_ = ecx, b_ = 0x12u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4c1157: cmp ecx, 0x12 */
    if ((sf == of)) goto L_4c1170;  /* 0x4c115a: jge 0x4c1170 */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff0u)))) & 0xffffffffu;  /* 0x4c115c: movsx edx, word ptr [ebp - 0x10] */
    eax = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1160: mov eax, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(eax + edx * 4u + 0xcd6u), 0x0u);  /* 0x4c1163: mov dword ptr [eax + edx*4 + 0xcd6], 0 */
    goto L_4c1147;  /* 0x4c116e: jmp 0x4c1147 */
L_4c1170:
    ecx = 0x1bu;  /* 0x4c1170: mov ecx, 0x1b */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4c1175: xor eax, eax */
    edi = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1177: mov edi, dword ptr [ebp - 0x1c] */
    { uint32_t a_ = edi, b_ = 0xd8au, r_; FL41_ADD(a_, b_, 0u, r_, 32); edi = r_; }  /* 0x4c117a: add edi, 0xd8a */
    /* 0x4c1180: rep stosd dword ptr es:[edi], eax */
    while (ecx != 0u) {
    WR32(edi, eax);
    edi += 4u;
    ecx -= 1u;
    }
    { uint32_t a_ = ecx, b_ = ecx, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x4c1182: xor ecx, ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1184: mov edx, dword ptr [ebp - 0x1c] */
    { uint32_t a_ = edx, b_ = 0xe72u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4c1187: add edx, 0xe72 */
    WR32((uint32_t)(edx), ecx);  /* 0x4c118d: mov dword ptr [edx], ecx */
    WR32((uint32_t)(edx + 0x4u), ecx);  /* 0x4c118f: mov dword ptr [edx + 4], ecx */
    WR32((uint32_t)(edx + 0x8u), ecx);  /* 0x4c1192: mov dword ptr [edx + 8], ecx */
    WR32((uint32_t)(edx + 0xcu), ecx);  /* 0x4c1195: mov dword ptr [edx + 0xc], ecx */
    eax = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1198: mov eax, dword ptr [ebp - 0x1c] */
    WR16((uint32_t)(eax + 0xe86u), 0x0u);  /* 0x4c119b: mov word ptr [eax + 0xe86], 0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c11a4: mov ecx, dword ptr [ebp - 0x1c] */
    esp -= 4u; WR32(esp, 0x4c11acu); FL41_CALL(0x4c94ecu); esp += 4u;  /* 0x4c11a7: call 0x4c94ec */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c11ac: mov ecx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(ecx + 0x38b0u), 0x1u);  /* 0x4c11af: mov dword ptr [ecx + 0x38b0], 1 */
    esp -= 4u; WR32(esp, 0x1764u);  /* 0x4c11b9: push 0x1764 */
    esp -= 4u; WR32(esp, 0x4c11c3u); FL41_CALL(0x51dc43u); esp += 4u;  /* 0x4c11be: call 0x51dc43 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4c11c3: add esp, 4 */
    WR32((uint32_t)(ebp + 0xffffffecu), eax);  /* 0x4c11c6: mov dword ptr [ebp - 0x14], eax */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c11c9: mov edx, dword ptr [ebp - 0x1c] */
    eax = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x4c11cc: mov eax, dword ptr [ebp - 0x14] */
    WR32((uint32_t)(edx + 0x1f24u), eax);  /* 0x4c11cf: mov dword ptr [edx + 0x1f24], eax */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xffffffecu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4c11d5: cmp dword ptr [ebp - 0x14], 0 */
    if (!zf) goto L_4c11f2;  /* 0x4c11d9: jne 0x4c11f2 */
    esp -= 4u; WR32(esp, 0x552c04u);  /* 0x4c11db: push 0x552c04 */
    ecx = 0x583979u;  /* 0x4c11e0: mov ecx, 0x583979 */
    esp -= 4u; WR32(esp, 0x4c11eau); FL41_CALL(0x4264e8u); esp += 4u; esp += 4u;  /* 0x4c11e5: call 0x4264e8 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c11ea: mov ecx, dword ptr [ebp - 0x1c] */
    esp -= 4u; WR32(esp, 0x4c11f2u); FL41_CALL(0x4c97b4u); esp += 4u;  /* 0x4c11ed: call 0x4c97b4 */
L_4c11f2:
    esp -= 4u; WR32(esp, 0x1764u);  /* 0x4c11f2: push 0x1764 */
    esp -= 4u; WR32(esp, 0x4c11fcu); FL41_CALL(0x51dc43u); esp += 4u;  /* 0x4c11f7: call 0x51dc43 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4c11fc: add esp, 4 */
    WR32((uint32_t)(ebp + 0xffffffe8u), eax);  /* 0x4c11ff: mov dword ptr [ebp - 0x18], eax */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1202: mov ecx, dword ptr [ebp - 0x1c] */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4c1205: mov edx, dword ptr [ebp - 0x18] */
    WR32((uint32_t)(ecx + 0x1f28u), edx);  /* 0x4c1208: mov dword ptr [ecx + 0x1f28], edx */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xffffffe8u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4c120e: cmp dword ptr [ebp - 0x18], 0 */
    if (!zf) goto L_4c122b;  /* 0x4c1212: jne 0x4c122b */
    esp -= 4u; WR32(esp, 0x552c6cu);  /* 0x4c1214: push 0x552c6c */
    ecx = 0x583979u;  /* 0x4c1219: mov ecx, 0x583979 */
    esp -= 4u; WR32(esp, 0x4c1223u); FL41_CALL(0x4264e8u); esp += 4u; esp += 4u;  /* 0x4c121e: call 0x4264e8 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1223: mov ecx, dword ptr [ebp - 0x1c] */
    esp -= 4u; WR32(esp, 0x4c122bu); FL41_CALL(0x4c97b4u); esp += 4u;  /* 0x4c1226: call 0x4c97b4 */
L_4c122b:
    ecx = 0x5d9u;  /* 0x4c122b: mov ecx, 0x5d9 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4c1230: xor eax, eax */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1232: mov edx, dword ptr [ebp - 0x1c] */
    edi = RD32((uint32_t)(edx + 0x1f24u));  /* 0x4c1235: mov edi, dword ptr [edx + 0x1f24] */
    /* 0x4c123b: rep stosd dword ptr es:[edi], eax */
    while (ecx != 0u) {
    WR32(edi, eax);
    edi += 4u;
    ecx -= 1u;
    }
    ecx = 0x5d9u;  /* 0x4c123d: mov ecx, 0x5d9 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4c1242: xor eax, eax */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1244: mov edx, dword ptr [ebp - 0x1c] */
    edi = RD32((uint32_t)(edx + 0x1f28u));  /* 0x4c1247: mov edi, dword ptr [edx + 0x1f28] */
    /* 0x4c124d: rep stosd dword ptr es:[edi], eax */
    while (ecx != 0u) {
    WR32(edi, eax);
    edi += 4u;
    ecx -= 1u;
    }
    eax = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c124f: mov eax, dword ptr [ebp - 0x1c] */
    ecx = RD32((uint32_t)(eax + 0x1f24u));  /* 0x4c1252: mov ecx, dword ptr [eax + 0x1f24] */
    WR32((uint32_t)(ecx + 0x175cu), 0xffffffffu);  /* 0x4c1258: mov dword ptr [ecx + 0x175c], 0xffffffff */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1262: mov edx, dword ptr [ebp - 0x1c] */
    eax = RD32((uint32_t)(edx + 0x1f28u));  /* 0x4c1265: mov eax, dword ptr [edx + 0x1f28] */
    WR32((uint32_t)(eax + 0x175cu), 0xffffffffu);  /* 0x4c126b: mov dword ptr [eax + 0x175c], 0xffffffff */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1275: mov ecx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(ecx + 0x1f2cu), 0x0u);  /* 0x4c1278: mov dword ptr [ecx + 0x1f2c], 0 */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1282: mov edx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(edx + 0x1f34u), 0x0u);  /* 0x4c1285: mov dword ptr [edx + 0x1f34], 0 */
    eax = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c128f: mov eax, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(eax + 0x1f30u), 0x0u);  /* 0x4c1292: mov dword ptr [eax + 0x1f30], 0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c129c: mov ecx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(ecx + 0xc4au), 0x0u);  /* 0x4c129f: mov dword ptr [ecx + 0xc4a], 0 */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c12a9: mov edx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(edx + 0xc4eu), 0x0u);  /* 0x4c12ac: mov dword ptr [edx + 0xc4e], 0 */
    eax = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c12b6: mov eax, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(eax + 0xc52u), 0x0u);  /* 0x4c12b9: mov dword ptr [eax + 0xc52], 0 */
    ecx = 0x180u;  /* 0x4c12c3: mov ecx, 0x180 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4c12c8: xor eax, eax */
    edi = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c12ca: mov edi, dword ptr [ebp - 0x1c] */
    { uint32_t a_ = edi, b_ = 0x4au, r_; FL41_ADD(a_, b_, 0u, r_, 32); edi = r_; }  /* 0x4c12cd: add edi, 0x4a */
    /* 0x4c12d0: rep stosd dword ptr es:[edi], eax */
    while (ecx != 0u) {
    WR32(edi, eax);
    edi += 4u;
    ecx -= 1u;
    }
    ecx = 0x180u;  /* 0x4c12d2: mov ecx, 0x180 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4c12d7: xor eax, eax */
    edi = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c12d9: mov edi, dword ptr [ebp - 0x1c] */
    { uint32_t a_ = edi, b_ = 0x64au, r_; FL41_ADD(a_, b_, 0u, r_, 32); edi = r_; }  /* 0x4c12dc: add edi, 0x64a */
    /* 0x4c12e2: rep stosd dword ptr es:[edi], eax */
    while (ecx != 0u) {
    WR32(edi, eax);
    edi += 4u;
    ecx -= 1u;
    }
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c12e4: mov ecx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(ecx + 0xc56u), 0x32u);  /* 0x4c12e7: mov dword ptr [ecx + 0xc56], 0x32 */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c12f1: mov edx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(edx + 0xc5au), 0x96u);  /* 0x4c12f4: mov dword ptr [edx + 0xc5a], 0x96 */
    eax = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c12fe: mov eax, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(eax + 0xc5eu), 0x64u);  /* 0x4c1301: mov dword ptr [eax + 0xc5e], 0x64 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c130b: mov ecx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(ecx + 0xc62u), 0x64u);  /* 0x4c130e: mov dword ptr [ecx + 0xc62], 0x64 */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1318: mov edx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(edx + 0xc66u), 0x0u);  /* 0x4c131b: mov dword ptr [edx + 0xc66], 0 */
    eax = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1325: mov eax, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(eax + 0xc6au), 0x0u);  /* 0x4c1328: mov dword ptr [eax + 0xc6a], 0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1332: mov ecx, dword ptr [ebp - 0x1c] */
    WR32((uint32_t)(ecx + 0xc6eu), 0x0u);  /* 0x4c1335: mov dword ptr [ecx + 0xc6e], 0 */
    WR32((uint32_t)(0x63a8d4u), 0x0u);  /* 0x4c133f: mov dword ptr [0x63a8d4], 0 */
    WR16((uint32_t)(ebp + 0xfffffff0u), 0x0u);  /* 0x4c1349: mov word ptr [ebp - 0x10], 0 */
    goto L_4c135d;  /* 0x4c134f: jmp 0x4c135d */
L_4c1351:
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffff0u))) & 0xffffu);  /* 0x4c1351: mov dx, word ptr [ebp - 0x10] */
    { uint32_t a_ = (edx & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); edx = (edx & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4c1355: add dx, 1 */
    WR16((uint32_t)(ebp + 0xfffffff0u), (edx & 0xffffu));  /* 0x4c1359: mov word ptr [ebp - 0x10], dx */
L_4c135d:
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff0u)))) & 0xffffffffu;  /* 0x4c135d: movsx eax, word ptr [ebp - 0x10] */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4c1361: cmp eax, 1 */
    if ((sf == of)) goto L_4c1381;  /* 0x4c1364: jge 0x4c1381 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff0u)))) & 0xffffffffu;  /* 0x4c1366: movsx ecx, word ptr [ebp - 0x10] */
    { uint32_t a_ = ecx, n_ = 0x6u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); ecx = r_; } }  /* 0x4c136a: shl ecx, 6 */
    edx = RD32((uint32_t)(0x63a8d4u));  /* 0x4c136d: mov edx, dword ptr [0x63a8d4] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ecx + 0x552be8u)), r_; r_ = a_ | b_; FL41_LOGIC(r_, 32); edx = r_; }  /* 0x4c1373: or edx, dword ptr [ecx + 0x552be8] */
    WR32((uint32_t)(0x63a8d4u), edx);  /* 0x4c1379: mov dword ptr [0x63a8d4], edx */
    goto L_4c1351;  /* 0x4c137f: jmp 0x4c1351 */
L_4c1381:
    WR32((uint32_t)(ebp + 0xfffffffcu), 0xffffffffu);  /* 0x4c1381: mov dword ptr [ebp - 4], 0xffffffff */
    eax = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4c1388: mov eax, dword ptr [ebp - 0x1c] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4c138b: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(FL41_TIB), ecx);  /* 0x4c138e: mov dword ptr fs:[0], ecx */
    edi = RD32(esp); esp += 4u;  /* 0x4c1395: pop edi */
    esp = ebp;  /* 0x4c1396: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4c1398: pop ebp */
    esp += 4u; goto done;  /* 0x4c1399: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4c4b12 (281 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4c4b12_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4c4b12: push ebp */
    ebp = esp;  /* 0x4c4b13: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x18u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4c4b15: sub esp, 0x18 */
    WR32((uint32_t)(ebp + 0xffffffe8u), ecx);  /* 0x4c4b18: mov dword ptr [ebp - 0x18], ecx */
    eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x4c4b1b: mov eax, dword ptr [ebp + 0xc] */
    { uint32_t a_ = eax, b_ = 0xffffu, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4c4b1e: and eax, 0xffff */
    { uint32_t a_ = eax, n_ = 0x10u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); eax = r_; } }  /* 0x4c4b23: shl eax, 0x10 */
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4c4b26: mov ecx, dword ptr [ebp + 0xc] */
    { uint32_t a_ = ecx, b_ = 0xffffu, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x4c4b29: and ecx, 0xffff */
    { uint32_t a_ = eax, b_ = ecx, r_; r_ = a_ | b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4c4b2f: or eax, ecx */
    WR32((uint32_t)(ebp + 0xffffffecu), eax);  /* 0x4c4b31: mov dword ptr [ebp - 0x14], eax */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4c4b34: mov edx, dword ptr [ebp + 8] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x2fu)))) & 0xffffffffu;  /* 0x4c4b37: movsx eax, word ptr [edx + 0x2f] */
    ecx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c4b3b: mov ecx, dword ptr [ebp + 0x10] */
    edx = RD32((uint32_t)(ecx + 0x4u));  /* 0x4c4b3e: mov edx, dword ptr [ecx + 4] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(eax); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4c4b41: imul edx, eax */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4c4b44: mov eax, dword ptr [ebp + 8] */
    ecx = RD32((uint32_t)(eax));  /* 0x4c4b47: mov ecx, dword ptr [eax] */
    { uint32_t a_ = ecx, b_ = edx, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4c4b49: add ecx, edx */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x639895u)))) & 0xffffffffu;  /* 0x4c4b4b: movsx edx, word ptr [0x639895] */
    eax = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c4b52: mov eax, dword ptr [ebp + 0x10] */
    eax = RD32((uint32_t)(eax));  /* 0x4c4b55: mov eax, dword ptr [eax] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(edx); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4c4b57: imul eax, edx */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4c4b5a: add ecx, eax */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4c4b5c: mov dword ptr [ebp - 4], ecx */
    ecx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c4b5f: mov ecx, dword ptr [ebp + 0x10] */
    edx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c4b62: mov edx, dword ptr [ebp + 0x10] */
    eax = RD32((uint32_t)(ecx + 0xcu));  /* 0x4c4b65: mov eax, dword ptr [ecx + 0xc] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(edx + 0x4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4c4b68: sub eax, dword ptr [edx + 4] */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4c4b6b: add eax, 1 */
    WR32((uint32_t)(ebp + 0xfffffff4u), eax);  /* 0x4c4b6e: mov dword ptr [ebp - 0xc], eax */
    ecx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c4b71: mov ecx, dword ptr [ebp + 0x10] */
    edx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c4b74: mov edx, dword ptr [ebp + 0x10] */
    eax = RD32((uint32_t)(ecx + 0x8u));  /* 0x4c4b77: mov eax, dword ptr [ecx + 8] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(edx)), r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4c4b7a: sub eax, dword ptr [edx] */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4c4b7c: add eax, 1 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x639895u)))) & 0xffffffffu;  /* 0x4c4b7f: movsx ecx, word ptr [0x639895] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(ecx); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4c4b86: imul eax, ecx */
    WR32((uint32_t)(ebp + 0xfffffff8u), eax);  /* 0x4c4b89: mov dword ptr [ebp - 8], eax */
    WR32((uint32_t)(ebp + 0xfffffff0u), 0x0u);  /* 0x4c4b8c: mov dword ptr [ebp - 0x10], 0 */
    goto L_4c4b9e;  /* 0x4c4b93: jmp 0x4c4b9e */
L_4c4b95:
    edx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4c4b95: mov edx, dword ptr [ebp - 0x10] */
    { uint32_t a_ = edx, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4c4b98: add edx, 1 */
    WR32((uint32_t)(ebp + 0xfffffff0u), edx);  /* 0x4c4b9b: mov dword ptr [ebp - 0x10], edx */
L_4c4b9e:
    eax = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4c4b9e: mov eax, dword ptr [ebp - 0x10] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(ebp + 0xfffffff4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4c4ba1: cmp eax, dword ptr [ebp - 0xc] */
    if ((sf == of)) goto L_4c4c25;  /* 0x4c4ba4: jge 0x4c4c25 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4c4ba6: mov ecx, dword ptr [ebp - 8] */
    { uint32_t a_ = ecx, b_ = 0x3u, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x4c4ba9: and ecx, 3 */
    { uint32_t a_ = ecx, b_ = ecx, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4c4bac: test ecx, ecx */
    if (!zf) goto L_4c4bcf;  /* 0x4c4bae: jne 0x4c4bcf */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4c4bb0: mov edx, dword ptr [ebp - 8] */
    { uint32_t a_ = edx, n_ = 0x2u, r_; if (n_ != 0u) { FL41_SAR(r_, a_, n_, 32); edx = r_; } }  /* 0x4c4bb3: sar edx, 2 */
    esp -= 4u; WR32(esp, edx);  /* 0x4c4bb6: push edx */
    eax = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x4c4bb7: mov eax, dword ptr [ebp - 0x14] */
    esp -= 4u; WR32(esp, eax);  /* 0x4c4bba: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4c4bbb: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4c4bbe: push ecx */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4c4bbf: mov ecx, dword ptr [ebp - 0x18] */
    { uint32_t a_ = ecx, b_ = 0x38ccu, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4c4bc2: add ecx, 0x38cc */
    esp -= 4u; WR32(esp, 0x4c4bcdu); FL41_CALL(0x43efb6u); esp += 12u; esp += 4u;  /* 0x4c4bc8: call 0x43efb6 */
    goto L_4c4c11;  /* 0x4c4bcd: jmp 0x4c4c11 */
L_4c4bcf:
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4c4bcf: mov edx, dword ptr [ebp - 8] */
    { uint32_t a_ = edx, b_ = 0x1u, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); edx = r_; }  /* 0x4c4bd2: and edx, 1 */
    { uint32_t a_ = edx, b_ = edx, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4c4bd5: test edx, edx */
    if (!zf) goto L_4c4bf8;  /* 0x4c4bd7: jne 0x4c4bf8 */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4c4bd9: mov eax, dword ptr [ebp - 8] */
    { uint32_t a_ = eax, n_ = 0x1u, r_; if (n_ != 0u) { FL41_SAR(r_, a_, n_, 32); eax = r_; } }  /* 0x4c4bdc: sar eax, 1 */
    esp -= 4u; WR32(esp, eax);  /* 0x4c4bde: push eax */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xcu))) & 0xffffu);  /* 0x4c4bdf: mov cx, word ptr [ebp + 0xc] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4c4be3: push ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4c4be4: mov edx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, edx);  /* 0x4c4be7: push edx */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4c4be8: mov ecx, dword ptr [ebp - 0x18] */
    { uint32_t a_ = ecx, b_ = 0x38ccu, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4c4beb: add ecx, 0x38cc */
    esp -= 4u; WR32(esp, 0x4c4bf6u); FL41_CALL(0x43ef77u); esp += 12u; esp += 4u;  /* 0x4c4bf1: call 0x43ef77 */
    goto L_4c4c11;  /* 0x4c4bf6: jmp 0x4c4c11 */
L_4c4bf8:
    esp -= 4u; WR32(esp, 0x55462cu);  /* 0x4c4bf8: push 0x55462c */
    ecx = 0x583979u;  /* 0x4c4bfd: mov ecx, 0x583979 */
    esp -= 4u; WR32(esp, 0x4c4c07u); FL41_CALL(0x4264e8u); esp += 4u; esp += 4u;  /* 0x4c4c02: call 0x4264e8 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4c4c07: mov ecx, dword ptr [ebp - 0x18] */
    esp -= 4u; WR32(esp, 0x4c4c0fu); FL41_CALL(0x4c97b4u); esp += 4u;  /* 0x4c4c0a: call 0x4c97b4 */
    goto L_4c4c25;  /* 0x4c4c0f: jmp 0x4c4c25 */
L_4c4c11:
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4c4c11: mov eax, dword ptr [ebp + 8] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x2fu)))) & 0xffffffffu;  /* 0x4c4c14: movsx ecx, word ptr [eax + 0x2f] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4c4c18: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = ecx, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4c4c1b: add edx, ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), edx);  /* 0x4c4c1d: mov dword ptr [ebp - 4], edx */
    goto L_4c4b95;  /* 0x4c4c20: jmp 0x4c4b95 */
L_4c4c25:
    esp = ebp;  /* 0x4c4c25: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4c4c27: pop ebp */
    esp += 16u; goto done;  /* 0x4c4c28: ret 0xc */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4c5770 (518 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4c5770_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4c5770: push ebp */
    ebp = esp;  /* 0x4c5771: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x1a0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4c5773: sub esp, 0x1a0 */
    esp -= 4u; WR32(esp, esi);  /* 0x4c5779: push esi */
    esp -= 4u; WR32(esp, edi);  /* 0x4c577a: push edi */
    WR32((uint32_t)(ebp + 0xfffffe60u), ecx);  /* 0x4c577b: mov dword ptr [ebp - 0x1a0], ecx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x63a4cdu)))) & 0xffffffffu;  /* 0x4c5781: movsx eax, word ptr [0x63a4cd] */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4c5788: test eax, eax */
    if (zf) goto L_4c586c;  /* 0x4c578a: je 0x4c586c */
    ecx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c5790: mov ecx, dword ptr [ebp + 0x10] */
    edx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c5793: mov edx, dword ptr [ebp + 0x10] */
    eax = RD32((uint32_t)(ecx + 0x8u));  /* 0x4c5796: mov eax, dword ptr [ecx + 8] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(edx)), r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4c5799: sub eax, dword ptr [edx] */
    WR32((uint32_t)(ebp + 0xfffffe64u), eax);  /* 0x4c579b: mov dword ptr [ebp - 0x19c], eax */
    ecx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c57a1: mov ecx, dword ptr [ebp + 0x10] */
    edx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c57a4: mov edx, dword ptr [ebp + 0x10] */
    eax = RD32((uint32_t)(ecx + 0xcu));  /* 0x4c57a7: mov eax, dword ptr [ecx + 0xc] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(edx + 0x4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4c57aa: sub eax, dword ptr [edx + 4] */
    WR32((uint32_t)(ebp + 0xfffffe68u), eax);  /* 0x4c57ad: mov dword ptr [ebp - 0x198], eax */
    ecx = RD32((uint32_t)(ebp + 0x14u));  /* 0x4c57b3: mov ecx, dword ptr [ebp + 0x14] */
    edx = RD32((uint32_t)(ebp + 0x14u));  /* 0x4c57b6: mov edx, dword ptr [ebp + 0x14] */
    eax = RD32((uint32_t)(ecx + 0x8u));  /* 0x4c57b9: mov eax, dword ptr [ecx + 8] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(edx)), r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4c57bc: sub eax, dword ptr [edx] */
    WR32((uint32_t)(ebp + 0xffffff6cu), eax);  /* 0x4c57be: mov dword ptr [ebp - 0x94], eax */
    ecx = RD32((uint32_t)(ebp + 0x14u));  /* 0x4c57c4: mov ecx, dword ptr [ebp + 0x14] */
    edx = RD32((uint32_t)(ebp + 0x14u));  /* 0x4c57c7: mov edx, dword ptr [ebp + 0x14] */
    eax = RD32((uint32_t)(ecx + 0xcu));  /* 0x4c57ca: mov eax, dword ptr [ecx + 0xc] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(edx + 0x4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4c57cd: sub eax, dword ptr [edx + 4] */
    WR32((uint32_t)(ebp + 0xfffffe6cu), eax);  /* 0x4c57d0: mov dword ptr [ebp - 0x194], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffe64u));  /* 0x4c57d6: mov ecx, dword ptr [ebp - 0x19c] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(ebp + 0xffffff6cu)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4c57dc: cmp ecx, dword ptr [ebp - 0x94] */
    if (!zf) goto L_4c57fe;  /* 0x4c57e2: jne 0x4c57fe */
    edx = RD32((uint32_t)(ebp + 0xfffffe68u));  /* 0x4c57e4: mov edx, dword ptr [ebp - 0x198] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ebp + 0xfffffe6cu)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4c57ea: cmp edx, dword ptr [ebp - 0x194] */
    if (!zf) goto L_4c57fe;  /* 0x4c57f0: jne 0x4c57fe */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0x8u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4c57f2: cmp dword ptr [ebp + 8], 0 */
    if (zf) goto L_4c57fe;  /* 0x4c57f6: je 0x4c57fe */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xcu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4c57f8: cmp dword ptr [ebp + 0xc], 0 */
    if (!zf) goto L_4c586c;  /* 0x4c57fc: jne 0x4c586c */
L_4c57fe:
    eax = RD32((uint32_t)(ebp + 0x14u));  /* 0x4c57fe: mov eax, dword ptr [ebp + 0x14] */
    ecx = RD32((uint32_t)(eax + 0xcu));  /* 0x4c5801: mov ecx, dword ptr [eax + 0xc] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4c5804: push ecx */
    edx = RD32((uint32_t)(ebp + 0x14u));  /* 0x4c5805: mov edx, dword ptr [ebp + 0x14] */
    eax = RD32((uint32_t)(edx + 0x8u));  /* 0x4c5808: mov eax, dword ptr [edx + 8] */
    esp -= 4u; WR32(esp, eax);  /* 0x4c580b: push eax */
    ecx = RD32((uint32_t)(ebp + 0x14u));  /* 0x4c580c: mov ecx, dword ptr [ebp + 0x14] */
    edx = RD32((uint32_t)(ecx + 0x4u));  /* 0x4c580f: mov edx, dword ptr [ecx + 4] */
    esp -= 4u; WR32(esp, edx);  /* 0x4c5812: push edx */
    eax = RD32((uint32_t)(ebp + 0x14u));  /* 0x4c5813: mov eax, dword ptr [ebp + 0x14] */
    ecx = RD32((uint32_t)(eax));  /* 0x4c5816: mov ecx, dword ptr [eax] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4c5818: push ecx */
    edx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c5819: mov edx, dword ptr [ebp + 0x10] */
    eax = RD32((uint32_t)(edx + 0xcu));  /* 0x4c581c: mov eax, dword ptr [edx + 0xc] */
    esp -= 4u; WR32(esp, eax);  /* 0x4c581f: push eax */
    ecx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c5820: mov ecx, dword ptr [ebp + 0x10] */
    edx = RD32((uint32_t)(ecx + 0x8u));  /* 0x4c5823: mov edx, dword ptr [ecx + 8] */
    esp -= 4u; WR32(esp, edx);  /* 0x4c5826: push edx */
    eax = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c5827: mov eax, dword ptr [ebp + 0x10] */
    ecx = RD32((uint32_t)(eax + 0x4u));  /* 0x4c582a: mov ecx, dword ptr [eax + 4] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4c582d: push ecx */
    edx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c582e: mov edx, dword ptr [ebp + 0x10] */
    eax = RD32((uint32_t)(edx));  /* 0x4c5831: mov eax, dword ptr [edx] */
    esp -= 4u; WR32(esp, eax);  /* 0x4c5833: push eax */
    ecx = RD32((uint32_t)(ebp + 0x1cu));  /* 0x4c5834: mov ecx, dword ptr [ebp + 0x1c] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4c5837: push ecx */
    esp -= 4u; WR32(esp, 0x554a7cu);  /* 0x4c5838: push 0x554a7c */
    edx = (uint32_t)(ebp + 0xfffffe70u);  /* 0x4c583d: lea edx, [ebp - 0x190] */
    esp -= 4u; WR32(esp, edx);  /* 0x4c5843: push edx */
    esp -= 4u; WR32(esp, 0x4c5849u); FL41_CALL(0x50ca3eu); esp += 4u;  /* 0x4c5844: call 0x50ca3e */
    { uint32_t a_ = esp, b_ = 0x2cu, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4c5849: add esp, 0x2c */
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4c584c: push 0 */
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4c584e: push 0 */
    eax = (uint32_t)(ebp + 0xfffffe70u);  /* 0x4c5850: lea eax, [ebp - 0x190] */
    esp -= 4u; WR32(esp, eax);  /* 0x4c5856: push eax */
    esp -= 4u; WR32(esp, 0x4c585cu); FL41_CALL(0x52139cu); esp += 12u; esp += 4u;  /* 0x4c5857: call 0x52139c */
    ecx = RD32((uint32_t)(ebp + 0xfffffe60u));  /* 0x4c585c: mov ecx, dword ptr [ebp - 0x1a0] */
    esp -= 4u; WR32(esp, 0x4c5867u); FL41_CALL(0x4c97b4u); esp += 4u;  /* 0x4c5862: call 0x4c97b4 */
    goto L_4c596e;  /* 0x4c5867: jmp 0x4c596e */
L_4c586c:
    ecx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c586c: mov ecx, dword ptr [ebp + 0x10] */
    edx = RD32((uint32_t)(ecx + 0x4u));  /* 0x4c586f: mov edx, dword ptr [ecx + 4] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(RD32((uint32_t)(ebp + 0x18u))); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4c5872: imul edx, dword ptr [ebp + 0x18] */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4c5876: mov eax, dword ptr [ebp + 8] */
    { uint32_t a_ = eax, b_ = edx, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4c5879: add eax, edx */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x639895u)))) & 0xffffffffu;  /* 0x4c587b: movsx ecx, word ptr [0x639895] */
    edx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c5882: mov edx, dword ptr [ebp + 0x10] */
    edx = RD32((uint32_t)(edx));  /* 0x4c5885: mov edx, dword ptr [edx] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(ecx); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4c5887: imul edx, ecx */
    { uint32_t a_ = eax, b_ = edx, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4c588a: add eax, edx */
    WR32((uint32_t)(ebp + 0xfffffff8u), eax);  /* 0x4c588c: mov dword ptr [ebp - 8], eax */
    esp -= 4u; WR32(esp, 0x20u);  /* 0x4c588f: push 0x20 */
    eax = RD32((uint32_t)(ebp + 0x1cu));  /* 0x4c5891: mov eax, dword ptr [ebp + 0x1c] */
    esp -= 4u; WR32(esp, eax);  /* 0x4c5894: push eax */
    ecx = (uint32_t)(ebp + 0xffffff78u);  /* 0x4c5895: lea ecx, [ebp - 0x88] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4c589b: push ecx */
    edx = RD32((uint32_t)(ebp + 0x14u));  /* 0x4c589c: mov edx, dword ptr [ebp + 0x14] */
    esp -= 4u; WR32(esp, edx);  /* 0x4c589f: push edx */
    eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x4c58a0: mov eax, dword ptr [ebp + 0xc] */
    esp -= 4u; WR32(esp, eax);  /* 0x4c58a3: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffe60u));  /* 0x4c58a4: mov ecx, dword ptr [ebp - 0x1a0] */
    esp -= 4u; WR32(esp, 0x4c58afu); FL41_CALL(0x4c4067u); esp += 20u; esp += 4u;  /* 0x4c58aa: call 0x4c4067 */
    ecx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c58af: mov ecx, dword ptr [ebp + 0x10] */
    edx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c58b2: mov edx, dword ptr [ebp + 0x10] */
    eax = RD32((uint32_t)(ecx + 0xcu));  /* 0x4c58b5: mov eax, dword ptr [ecx + 0xc] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(edx + 0x4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4c58b8: sub eax, dword ptr [edx + 4] */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4c58bb: add eax, 1 */
    WR32((uint32_t)(ebp + 0xffffff74u), eax);  /* 0x4c58be: mov dword ptr [ebp - 0x8c], eax */
    ecx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c58c4: mov ecx, dword ptr [ebp + 0x10] */
    edx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4c58c7: mov edx, dword ptr [ebp + 0x10] */
    eax = RD32((uint32_t)(ecx + 0x8u));  /* 0x4c58ca: mov eax, dword ptr [ecx + 8] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(edx)), r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4c58cd: sub eax, dword ptr [edx] */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4c58cf: add eax, 1 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x639895u)))) & 0xffffffffu;  /* 0x4c58d2: movsx ecx, word ptr [0x639895] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(ecx); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4c58d9: imul eax, ecx */
    WR32((uint32_t)(ebp + 0xfffffff4u), eax);  /* 0x4c58dc: mov dword ptr [ebp - 0xc], eax */
    edx = RD32((uint32_t)(ebp + 0xffffff9cu));  /* 0x4c58df: mov edx, dword ptr [ebp - 0x64] */
    WR32((uint32_t)(ebp + 0xfffffffcu), edx);  /* 0x4c58e2: mov dword ptr [ebp - 4], edx */
    WR32((uint32_t)(ebp + 0xffffff70u), 0x0u);  /* 0x4c58e5: mov dword ptr [ebp - 0x90], 0 */
    goto L_4c5900;  /* 0x4c58ef: jmp 0x4c5900 */
L_4c58f1:
    eax = RD32((uint32_t)(ebp + 0xffffff70u));  /* 0x4c58f1: mov eax, dword ptr [ebp - 0x90] */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4c58f7: add eax, 1 */
    WR32((uint32_t)(ebp + 0xffffff70u), eax);  /* 0x4c58fa: mov dword ptr [ebp - 0x90], eax */
L_4c5900:
    ecx = RD32((uint32_t)(ebp + 0xffffff70u));  /* 0x4c5900: mov ecx, dword ptr [ebp - 0x90] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(ebp + 0xffffff74u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4c5906: cmp ecx, dword ptr [ebp - 0x8c] */
    if ((sf == of)) goto L_4c5939;  /* 0x4c590c: jge 0x4c5939 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4c590e: mov ecx, dword ptr [ebp - 0xc] */
    esi = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4c5911: mov esi, dword ptr [ebp - 8] */
    edi = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4c5914: mov edi, dword ptr [ebp - 4] */
    edx = ecx;  /* 0x4c5917: mov edx, ecx */
    { uint32_t a_ = ecx, n_ = 0x2u, r_; if (n_ != 0u) { FL41_SHR(r_, a_, n_, 32); ecx = r_; } }  /* 0x4c5919: shr ecx, 2 */
    /* 0x4c591c: rep movsd dword ptr es:[edi], dword ptr [esi] */
    while (ecx != 0u) {
    WR32(edi, RD32(esi));
    esi += 4u; edi += 4u;
    ecx -= 1u;
    }
    ecx = edx;  /* 0x4c591e: mov ecx, edx */
    { uint32_t a_ = ecx, b_ = 0x3u, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x4c5920: and ecx, 3 */
    /* 0x4c5923: rep movsb byte ptr es:[edi], byte ptr [esi] */
    while (ecx != 0u) {
    WR8(edi, RD8(esi));
    esi += 1u; edi += 1u;
    ecx -= 1u;
    }
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4c5925: mov eax, dword ptr [ebp - 8] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(ebp + 0x18u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4c5928: add eax, dword ptr [ebp + 0x18] */
    WR32((uint32_t)(ebp + 0xfffffff8u), eax);  /* 0x4c592b: mov dword ptr [ebp - 8], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4c592e: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(ebp + 0xffffff88u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4c5931: add ecx, dword ptr [ebp - 0x78] */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4c5934: mov dword ptr [ebp - 4], ecx */
    goto L_4c58f1;  /* 0x4c5937: jmp 0x4c58f1 */
L_4c5939:
    esp -= 4u; WR32(esp, 0x554b20u);  /* 0x4c5939: push 0x554b20 */
    edx = RD32((uint32_t)(ebp + 0x14u));  /* 0x4c593e: mov edx, dword ptr [ebp + 0x14] */
    esp -= 4u; WR32(esp, edx);  /* 0x4c5941: push edx */
    eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x4c5942: mov eax, dword ptr [ebp + 0xc] */
    esp -= 4u; WR32(esp, eax);  /* 0x4c5945: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffe60u));  /* 0x4c5946: mov ecx, dword ptr [ebp - 0x1a0] */
    esp -= 4u; WR32(esp, 0x4c5951u); FL41_CALL(0x4c4202u); esp += 12u; esp += 4u;  /* 0x4c594c: call 0x4c4202 */
    ecx = RD32((uint32_t)(ebp + 0xfffffe60u));  /* 0x4c5951: mov ecx, dword ptr [ebp - 0x1a0] */
    edx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4c5957: mov edx, dword ptr [ebp + 0xc] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ecx + 0xcu)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4c595a: cmp edx, dword ptr [ecx + 0xc] */
    if (!zf) goto L_4c596e;  /* 0x4c595d: jne 0x4c596e */
    eax = RD32((uint32_t)(ebp + 0x14u));  /* 0x4c595f: mov eax, dword ptr [ebp + 0x14] */
    esp -= 4u; WR32(esp, eax);  /* 0x4c5962: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffe60u));  /* 0x4c5963: mov ecx, dword ptr [ebp - 0x1a0] */
    esp -= 4u; WR32(esp, 0x4c596eu); FL41_CALL(0x4c952fu); esp += 4u; esp += 4u;  /* 0x4c5969: call 0x4c952f */
L_4c596e:
    edi = RD32(esp); esp += 4u;  /* 0x4c596e: pop edi */
    esi = RD32(esp); esp += 4u;  /* 0x4c596f: pop esi */
    esp = ebp;  /* 0x4c5970: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4c5972: pop ebp */
    esp += 28u; goto done;  /* 0x4c5973: ret 0x18 */
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

/* GAME.EXE 0x4d0275 (405 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4d0275_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4d0275: push ebp */
    ebp = esp;  /* 0x4d0276: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x14u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4d0278: sub esp, 0x14 */
    WR16((uint32_t)(ebp + 0xfffffffcu), 0x0u);  /* 0x4d027b: mov word ptr [ebp - 4], 0 */
    goto L_4d028f;  /* 0x4d0281: jmp 0x4d028f */
L_4d0283:
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffffcu))) & 0xffffu);  /* 0x4d0283: mov ax, word ptr [ebp - 4] */
    { uint32_t a_ = (eax & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); eax = (eax & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4d0287: add ax, 1 */
    WR16((uint32_t)(ebp + 0xfffffffcu), (eax & 0xffffu));  /* 0x4d028b: mov word ptr [ebp - 4], ax */
L_4d028f:
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4d028f: movsx ecx, word ptr [ebp - 4] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x5b51acu)))) & 0xffffffffu;  /* 0x4d0293: movsx edx, word ptr [0x5b51ac] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4d029a: imul edx, edx, 0x8d */
    eax = RD32((uint32_t)(edx + 0x5bb5e5u));  /* 0x4d02a0: mov eax, dword ptr [edx + 0x5bb5e5] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x21u)))) & 0xffffffffu;  /* 0x4d02a6: movsx edx, word ptr [eax + 0x21] */
    { uint32_t a_ = ecx, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d02aa: cmp ecx, edx */
    if ((sf == of)) goto L_4d0406;  /* 0x4d02ac: jge 0x4d0406 */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x5b51acu)))) & 0xffffffffu;  /* 0x4d02b2: movsx eax, word ptr [0x5b51ac] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4d02b9: imul eax, eax, 0x8d */
    ecx = RD32((uint32_t)(eax + 0x5bb5e5u));  /* 0x4d02bf: mov ecx, dword ptr [eax + 0x5bb5e5] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4d02c5: movsx edx, word ptr [ebp - 4] */
    { uint32_t a_ = edx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); edx = r_; } }  /* 0x4d02c9: shl edx, 4 */
    eax = RD32((uint32_t)(ecx + edx + 0xe9u));  /* 0x4d02cc: mov eax, dword ptr [ecx + edx + 0xe9] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4d02d3: add eax, dword ptr [0x58318a] */
    WR32((uint32_t)(ebp + 0xfffffff0u), eax);  /* 0x4d02d9: mov dword ptr [ebp - 0x10], eax */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x5b51acu)))) & 0xffffffffu;  /* 0x4d02dc: movsx ecx, word ptr [0x5b51ac] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4d02e3: imul ecx, ecx, 0x8d */
    edx = RD32((uint32_t)(ecx + 0x5bb5e5u));  /* 0x4d02e9: mov edx, dword ptr [ecx + 0x5bb5e5] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4d02ef: movsx eax, word ptr [ebp - 4] */
    { uint32_t a_ = eax, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); eax = r_; } }  /* 0x4d02f3: shl eax, 4 */
    ecx = RD32((uint32_t)(edx + eax + 0xf1u));  /* 0x4d02f6: mov ecx, dword ptr [edx + eax + 0xf1] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d02fd: add ecx, dword ptr [0x58318a] */
    WR32((uint32_t)(ebp + 0xfffffff8u), ecx);  /* 0x4d0303: mov dword ptr [ebp - 8], ecx */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x5b51acu)))) & 0xffffffffu;  /* 0x4d0306: movsx edx, word ptr [0x5b51ac] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4d030d: imul edx, edx, 0x8d */
    eax = RD32((uint32_t)(edx + 0x5bb5e5u));  /* 0x4d0313: mov eax, dword ptr [edx + 0x5bb5e5] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4d0319: movsx ecx, word ptr [ebp - 4] */
    { uint32_t a_ = ecx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); ecx = r_; } }  /* 0x4d031d: shl ecx, 4 */
    edx = RD32((uint32_t)(eax + ecx + 0xe5u));  /* 0x4d0320: mov edx, dword ptr [eax + ecx + 0xe5] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4d0327: add edx, dword ptr [0x583186] */
    WR32((uint32_t)(ebp + 0xffffffecu), edx);  /* 0x4d032d: mov dword ptr [ebp - 0x14], edx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x5b51acu)))) & 0xffffffffu;  /* 0x4d0330: movsx eax, word ptr [0x5b51ac] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4d0337: imul eax, eax, 0x8d */
    ecx = RD32((uint32_t)(eax + 0x5bb5e5u));  /* 0x4d033d: mov ecx, dword ptr [eax + 0x5bb5e5] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4d0343: movsx edx, word ptr [ebp - 4] */
    { uint32_t a_ = edx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); edx = r_; } }  /* 0x4d0347: shl edx, 4 */
    eax = RD32((uint32_t)(ecx + edx + 0xedu));  /* 0x4d034a: mov eax, dword ptr [ecx + edx + 0xed] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4d0351: add eax, dword ptr [0x583186] */
    WR32((uint32_t)(ebp + 0xfffffff4u), eax);  /* 0x4d0357: mov dword ptr [ebp - 0xc], eax */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4d035a: movsx ecx, word ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(ecx * 4u + 0x5b518bu)), b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d035e: cmp dword ptr [ecx*4 + 0x5b518b], 1 */
    if (!zf) goto L_4d03ba;  /* 0x4d0366: jne 0x4d03ba */
    esp -= 4u; WR32(esp, 0x559f68u);  /* 0x4d0368: push 0x559f68 */
    edx = (uint32_t)(ebp + 0xffffffecu);  /* 0x4d036d: lea edx, [ebp - 0x14] */
    esp -= 4u; WR32(esp, edx);  /* 0x4d0370: push edx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x5b51acu)))) & 0xffffffffu;  /* 0x4d0371: movsx eax, word ptr [0x5b51ac] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4d0378: imul eax, eax, 0x8d */
    ecx = RD32((uint32_t)(eax + 0x5bb5e5u));  /* 0x4d037e: mov ecx, dword ptr [eax + 0x5bb5e5] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4d0384: movsx edx, word ptr [ebp - 4] */
    { uint32_t a_ = edx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); edx = r_; } }  /* 0x4d0388: shl edx, 4 */
    eax = (uint32_t)(ecx + edx + 0xe5u);  /* 0x4d038b: lea eax, [ecx + edx + 0xe5] */
    esp -= 4u; WR32(esp, eax);  /* 0x4d0392: push eax */
    ecx = RD32((uint32_t)(0x5cf665u));  /* 0x4d0393: mov ecx, dword ptr [0x5cf665] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d0399: push ecx */
    edx = RD32((uint32_t)(0x5d15e3u));  /* 0x4d039a: mov edx, dword ptr [0x5d15e3] */
    esp -= 4u; WR32(esp, edx);  /* 0x4d03a0: push edx */
    ecx = 0x5cf659u;  /* 0x4d03a1: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4d03abu); FL41_CALL(0x4c5377u); esp += 20u; esp += 4u;  /* 0x4d03a6: call 0x4c5377 */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4d03ab: movsx eax, word ptr [ebp - 4] */
    WR32((uint32_t)(eax * 4u + 0x5b518bu), 0x0u);  /* 0x4d03af: mov dword ptr [eax*4 + 0x5b518b], 0 */
L_4d03ba:
    esp -= 4u; WR32(esp, 0x559f80u);  /* 0x4d03ba: push 0x559f80 */
    ecx = (uint32_t)(ebp + 0xffffffecu);  /* 0x4d03bf: lea ecx, [ebp - 0x14] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d03c2: push ecx */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x5b51acu)))) & 0xffffffffu;  /* 0x4d03c3: movsx edx, word ptr [0x5b51ac] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4d03ca: imul edx, edx, 0x8d */
    eax = RD32((uint32_t)(edx + 0x5bb5e5u));  /* 0x4d03d0: mov eax, dword ptr [edx + 0x5bb5e5] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4d03d6: movsx ecx, word ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx * 4u + 0x5b516bu));  /* 0x4d03da: mov edx, dword ptr [ecx*4 + 0x5b516b] */
    { uint32_t a_ = edx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); edx = r_; } }  /* 0x4d03e1: shl edx, 4 */
    eax = (uint32_t)(eax + edx + 0x25u);  /* 0x4d03e4: lea eax, [eax + edx + 0x25] */
    esp -= 4u; WR32(esp, eax);  /* 0x4d03e8: push eax */
    ecx = RD32((uint32_t)(0x5cf665u));  /* 0x4d03e9: mov ecx, dword ptr [0x5cf665] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d03ef: push ecx */
    edx = RD32((uint32_t)(0x5d1acdu));  /* 0x4d03f0: mov edx, dword ptr [0x5d1acd] */
    esp -= 4u; WR32(esp, edx);  /* 0x4d03f6: push edx */
    ecx = 0x5cf659u;  /* 0x4d03f7: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4d0401u); FL41_CALL(0x4c5d4bu); esp += 20u; esp += 4u;  /* 0x4d03fc: call 0x4c5d4b */
    goto L_4d0283;  /* 0x4d0401: jmp 0x4d0283 */
L_4d0406:
    esp = ebp;  /* 0x4d0406: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4d0408: pop ebp */
    esp += 4u; goto done;  /* 0x4d0409: ret  */
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

/* GAME.EXE 0x4d5316 (843 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4d5316_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4d5316: push ebp */
    ebp = esp;  /* 0x4d5317: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d5319: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4d531a: mov dword ptr [ebp - 4], ecx */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0x8u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d531d: cmp dword ptr [ebp + 8], 0 */
    if (zf) goto L_4d5329;  /* 0x4d5321: je 0x4d5329 */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xcu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d5323: cmp dword ptr [ebp + 0xc], 0 */
    if (!zf) goto L_4d5330;  /* 0x4d5327: jne 0x4d5330 */
L_4d5329:
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4d5329: xor eax, eax */
    goto L_4d565b;  /* 0x4d532b: jmp 0x4d565b */
L_4d5330:
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d5330: mov eax, dword ptr [ebp + 8] */
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4d5333: mov ecx, dword ptr [ebp + 0xc] */
    edx = RD32((uint32_t)(eax + 0x8u));  /* 0x4d5336: mov edx, dword ptr [eax + 8] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ecx)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d5339: cmp edx, dword ptr [ecx] */
    if ((sf != of)) goto L_4d5366;  /* 0x4d533b: jl 0x4d5366 */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d533d: mov eax, dword ptr [ebp + 8] */
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4d5340: mov ecx, dword ptr [ebp + 0xc] */
    edx = RD32((uint32_t)(eax));  /* 0x4d5343: mov edx, dword ptr [eax] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ecx + 0x8u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d5345: cmp edx, dword ptr [ecx + 8] */
    if ((!zf && sf == of)) goto L_4d5366;  /* 0x4d5348: jg 0x4d5366 */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d534a: mov eax, dword ptr [ebp + 8] */
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4d534d: mov ecx, dword ptr [ebp + 0xc] */
    edx = RD32((uint32_t)(eax + 0xcu));  /* 0x4d5350: mov edx, dword ptr [eax + 0xc] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ecx + 0x4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d5353: cmp edx, dword ptr [ecx + 4] */
    if ((sf != of)) goto L_4d5366;  /* 0x4d5356: jl 0x4d5366 */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d5358: mov eax, dword ptr [ebp + 8] */
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4d535b: mov ecx, dword ptr [ebp + 0xc] */
    edx = RD32((uint32_t)(eax + 0x4u));  /* 0x4d535e: mov edx, dword ptr [eax + 4] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ecx + 0xcu)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d5361: cmp edx, dword ptr [ecx + 0xc] */
    if ((zf || sf != of)) goto L_4d536d;  /* 0x4d5364: jle 0x4d536d */
L_4d5366:
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4d5366: xor eax, eax */
    goto L_4d565b;  /* 0x4d5368: jmp 0x4d565b */
L_4d536d:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d536d: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4d5375u); FL41_CALL(0x4d52b9u); esp += 4u;  /* 0x4d5370: call 0x4d52b9 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5375: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x34u), 0x0u);  /* 0x4d5378: mov dword ptr [eax + 0x34], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d537f: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x24u), 0x0u);  /* 0x4d5382: mov dword ptr [ecx + 0x24], 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5389: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x14u), 0x0u);  /* 0x4d538c: mov dword ptr [edx + 0x14], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5393: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x4u), 0x0u);  /* 0x4d5396: mov dword ptr [eax + 4], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d539d: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x74u), 0x1u);  /* 0x4d53a0: mov dword ptr [ecx + 0x74], 1 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d53a7: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x64u), 0x1u);  /* 0x4d53aa: mov dword ptr [edx + 0x64], 1 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d53b1: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x54u), 0x1u);  /* 0x4d53b4: mov dword ptr [eax + 0x54], 1 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d53bb: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x44u), 0x1u);  /* 0x4d53be: mov dword ptr [ecx + 0x44], 1 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d53c5: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x18u), 0x0u);  /* 0x4d53c8: mov dword ptr [edx + 0x18], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d53cf: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x8u), 0x0u);  /* 0x4d53d2: mov dword ptr [eax + 8], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d53d9: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x58u), 0x0u);  /* 0x4d53dc: mov dword ptr [ecx + 0x58], 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d53e3: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x48u), 0x0u);  /* 0x4d53e6: mov dword ptr [edx + 0x48], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d53ed: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x38u), 0x1u);  /* 0x4d53f0: mov dword ptr [eax + 0x38], 1 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d53f7: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x28u), 0x1u);  /* 0x4d53fa: mov dword ptr [ecx + 0x28], 1 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5401: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x78u), 0x1u);  /* 0x4d5404: mov dword ptr [edx + 0x78], 1 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d540b: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x68u), 0x1u);  /* 0x4d540e: mov dword ptr [eax + 0x68], 1 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5415: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x2cu), 0x0u);  /* 0x4d5418: mov dword ptr [ecx + 0x2c], 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d541f: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0xcu), 0x0u);  /* 0x4d5422: mov dword ptr [edx + 0xc], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5429: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x6cu), 0x0u);  /* 0x4d542c: mov dword ptr [eax + 0x6c], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5433: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x4cu), 0x0u);  /* 0x4d5436: mov dword ptr [ecx + 0x4c], 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d543d: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x3cu), 0x1u);  /* 0x4d5440: mov dword ptr [edx + 0x3c], 1 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5447: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x1cu), 0x1u);  /* 0x4d544a: mov dword ptr [eax + 0x1c], 1 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5451: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x7cu), 0x1u);  /* 0x4d5454: mov dword ptr [ecx + 0x7c], 1 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d545b: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x5cu), 0x1u);  /* 0x4d545e: mov dword ptr [edx + 0x5c], 1 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5465: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d5468: mov ecx, dword ptr [ebp + 8] */
    edx = RD32((uint32_t)(ecx));  /* 0x4d546b: mov edx, dword ptr [ecx] */
    WR32((uint32_t)(eax + 0x10u), edx);  /* 0x4d546d: mov dword ptr [eax + 0x10], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5470: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d5473: mov ecx, dword ptr [ebp + 8] */
    edx = RD32((uint32_t)(ecx + 0x4u));  /* 0x4d5476: mov edx, dword ptr [ecx + 4] */
    WR32((uint32_t)(eax + 0x20u), edx);  /* 0x4d5479: mov dword ptr [eax + 0x20], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d547c: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d547f: mov ecx, dword ptr [ebp + 8] */
    edx = RD32((uint32_t)(ecx + 0x8u));  /* 0x4d5482: mov edx, dword ptr [ecx + 8] */
    WR32((uint32_t)(eax + 0x30u), edx);  /* 0x4d5485: mov dword ptr [eax + 0x30], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5488: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d548b: mov ecx, dword ptr [ebp + 8] */
    edx = RD32((uint32_t)(ecx + 0xcu));  /* 0x4d548e: mov edx, dword ptr [ecx + 0xc] */
    WR32((uint32_t)(eax + 0x40u), edx);  /* 0x4d5491: mov dword ptr [eax + 0x40], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5494: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4d5497: mov ecx, dword ptr [ebp + 0xc] */
    edx = RD32((uint32_t)(ecx));  /* 0x4d549a: mov edx, dword ptr [ecx] */
    WR32((uint32_t)(eax + 0x50u), edx);  /* 0x4d549c: mov dword ptr [eax + 0x50], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d549f: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4d54a2: mov ecx, dword ptr [ebp + 0xc] */
    edx = RD32((uint32_t)(ecx + 0x4u));  /* 0x4d54a5: mov edx, dword ptr [ecx + 4] */
    WR32((uint32_t)(eax + 0x60u), edx);  /* 0x4d54a8: mov dword ptr [eax + 0x60], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d54ab: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4d54ae: mov ecx, dword ptr [ebp + 0xc] */
    edx = RD32((uint32_t)(ecx + 0x8u));  /* 0x4d54b1: mov edx, dword ptr [ecx + 8] */
    WR32((uint32_t)(eax + 0x70u), edx);  /* 0x4d54b4: mov dword ptr [eax + 0x70], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d54b7: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4d54ba: mov ecx, dword ptr [ebp + 0xc] */
    edx = RD32((uint32_t)(ecx + 0xcu));  /* 0x4d54bd: mov edx, dword ptr [ecx + 0xc] */
    WR32((uint32_t)(eax + 0x80u), edx);  /* 0x4d54c0: mov dword ptr [eax + 0x80], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d54c6: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4d54c9: add eax, 4 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d54cc: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x84u), eax);  /* 0x4d54cf: mov dword ptr [ecx + 0x84], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d54d5: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x24u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4d54d8: add edx, 0x24 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d54db: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x88u), edx);  /* 0x4d54de: mov dword ptr [eax + 0x88], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d54e4: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x44u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d54e7: add ecx, 0x44 */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d54ea: push ecx */
    esp -= 4u; WR32(esp, 0x2u);  /* 0x4d54eb: push 2 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d54ed: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x84u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4d54f0: add edx, 0x84 */
    esp -= 4u; WR32(esp, edx);  /* 0x4d54f6: push edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d54f7: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4d54ffu); FL41_CALL(0x4d5661u); esp += 12u; esp += 4u;  /* 0x4d54fa: call 0x4d5661 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d54ff: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = 0x64u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4d5502: add eax, 0x64 */
    esp -= 4u; WR32(esp, eax);  /* 0x4d5505: push eax */
    esp -= 4u; WR32(esp, 0x3u);  /* 0x4d5506: push 3 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5508: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x84u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d550b: add ecx, 0x84 */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d5511: push ecx */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5512: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4d551au); FL41_CALL(0x4d5661u); esp += 12u; esp += 4u;  /* 0x4d5515: call 0x4d5661 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d551a: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x14u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4d551d: add edx, 0x14 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5520: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x94u), edx);  /* 0x4d5523: mov dword ptr [eax + 0x94], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5529: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x34u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d552c: add ecx, 0x34 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d552f: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x98u), ecx);  /* 0x4d5532: mov dword ptr [edx + 0x98], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5538: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = 0x54u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4d553b: add eax, 0x54 */
    esp -= 4u; WR32(esp, eax);  /* 0x4d553e: push eax */
    esp -= 4u; WR32(esp, 0x2u);  /* 0x4d553f: push 2 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5541: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x94u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d5544: add ecx, 0x94 */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d554a: push ecx */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d554b: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4d5553u); FL41_CALL(0x4d5661u); esp += 12u; esp += 4u;  /* 0x4d554e: call 0x4d5661 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5553: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x74u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4d5556: add edx, 0x74 */
    esp -= 4u; WR32(esp, edx);  /* 0x4d5559: push edx */
    esp -= 4u; WR32(esp, 0x3u);  /* 0x4d555a: push 3 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d555c: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = 0x94u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4d555f: add eax, 0x94 */
    esp -= 4u; WR32(esp, eax);  /* 0x4d5564: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5565: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4d556du); FL41_CALL(0x4d5661u); esp += 12u; esp += 4u;  /* 0x4d5568: call 0x4d5661 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d556d: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x84u));  /* 0x4d5570: mov edx, dword ptr [ecx + 0x84] */
    { uint32_t a_ = RD32((uint32_t)(edx + 0x4u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d5576: cmp dword ptr [edx + 4], 0 */
    if (!zf) goto L_4d55c4;  /* 0x4d557a: jne 0x4d55c4 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d557c: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x88u));  /* 0x4d557f: mov ecx, dword ptr [eax + 0x88] */
    { uint32_t a_ = RD32((uint32_t)(ecx + 0x4u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d5585: cmp dword ptr [ecx + 4], 0 */
    if (!zf) goto L_4d55c4;  /* 0x4d5589: jne 0x4d55c4 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d558b: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x8cu));  /* 0x4d558e: mov eax, dword ptr [edx + 0x8c] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x4u)), b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d5594: cmp dword ptr [eax + 4], 1 */
    if (!zf) goto L_4d55c4;  /* 0x4d5598: jne 0x4d55c4 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d559a: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x88u));  /* 0x4d559d: mov edx, dword ptr [ecx + 0x88] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d55a3: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(edx + 0xcu));  /* 0x4d55a6: mov ecx, dword ptr [edx + 0xc] */
    WR32((uint32_t)(eax + 0xa4u), ecx);  /* 0x4d55a9: mov dword ptr [eax + 0xa4], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d55af: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x8cu));  /* 0x4d55b2: mov eax, dword ptr [edx + 0x8c] */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d55b8: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(eax + 0xcu));  /* 0x4d55bb: mov edx, dword ptr [eax + 0xc] */
    WR32((uint32_t)(ecx + 0xacu), edx);  /* 0x4d55be: mov dword ptr [ecx + 0xac], edx */
L_4d55c4:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d55c4: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x94u));  /* 0x4d55c7: mov ecx, dword ptr [eax + 0x94] */
    { uint32_t a_ = RD32((uint32_t)(ecx + 0x4u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d55cd: cmp dword ptr [ecx + 4], 0 */
    if (!zf) goto L_4d561b;  /* 0x4d55d1: jne 0x4d561b */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d55d3: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x98u));  /* 0x4d55d6: mov eax, dword ptr [edx + 0x98] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x4u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d55dc: cmp dword ptr [eax + 4], 0 */
    if (!zf) goto L_4d561b;  /* 0x4d55e0: jne 0x4d561b */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d55e2: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x9cu));  /* 0x4d55e5: mov edx, dword ptr [ecx + 0x9c] */
    { uint32_t a_ = RD32((uint32_t)(edx + 0x4u)), b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d55eb: cmp dword ptr [edx + 4], 1 */
    if (!zf) goto L_4d561b;  /* 0x4d55ef: jne 0x4d561b */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d55f1: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x98u));  /* 0x4d55f4: mov ecx, dword ptr [eax + 0x98] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d55fa: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ecx + 0xcu));  /* 0x4d55fd: mov eax, dword ptr [ecx + 0xc] */
    WR32((uint32_t)(edx + 0xa8u), eax);  /* 0x4d5600: mov dword ptr [edx + 0xa8], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5606: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x9cu));  /* 0x4d5609: mov edx, dword ptr [ecx + 0x9c] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d560f: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(edx + 0xcu));  /* 0x4d5612: mov ecx, dword ptr [edx + 0xc] */
    WR32((uint32_t)(eax + 0xb0u), ecx);  /* 0x4d5615: mov dword ptr [eax + 0xb0], ecx */
L_4d561b:
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d561b: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d561e: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(edx + 0xb0u));  /* 0x4d5621: mov ecx, dword ptr [edx + 0xb0] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(eax + 0xa8u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d5627: sub ecx, dword ptr [eax + 0xa8] */
    { uint32_t a_ = ecx, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d562d: add ecx, 1 */
    { uint32_t a_ = ecx, b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d5630: cmp ecx, 1 */
    if ((sf != of)) goto L_4d564f;  /* 0x4d5633: jl 0x4d564f */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5635: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5638: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(edx + 0xacu));  /* 0x4d563b: mov ecx, dword ptr [edx + 0xac] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(eax + 0xa4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d5641: sub ecx, dword ptr [eax + 0xa4] */
    { uint32_t a_ = ecx, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d5647: add ecx, 1 */
    { uint32_t a_ = ecx, b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d564a: cmp ecx, 1 */
    if ((sf == of)) goto L_4d5653;  /* 0x4d564d: jge 0x4d5653 */
L_4d564f:
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4d564f: xor eax, eax */
    goto L_4d565b;  /* 0x4d5651: jmp 0x4d565b */
L_4d5653:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5653: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = 0xa4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4d5656: add eax, 0xa4 */
L_4d565b:
    esp = ebp;  /* 0x4d565b: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4d565d: pop ebp */
    esp += 12u; goto done;  /* 0x4d565e: ret 8 */
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

/* GAME.EXE 0x4d65e9 (284 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4d65e9_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4d65e9: push ebp */
    ebp = esp;  /* 0x4d65ea: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x8u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4d65ec: sub esp, 8 */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4d65ef: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d65f2: mov eax, dword ptr [ebp + 8] */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d65f5: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + eax * 4u + 0x94e2u));  /* 0x4d65f8: mov edx, dword ptr [ecx + eax*4 + 0x94e2] */
    { uint32_t a_ = edx, b_ = 0x35u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4d65ff: add edx, 0x35 */
    esp -= 4u; WR32(esp, edx);  /* 0x4d6602: push edx */
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(0x5d2f29u))) & 0xffffu);  /* 0x4d6603: mov ax, word ptr [0x5d2f29] */
    esp -= 4u; WR32(esp, eax);  /* 0x4d6609: push eax */
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d660a: mov ecx, dword ptr [ebp + 8] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d660d: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + ecx * 4u + 0x94e2u));  /* 0x4d6610: mov eax, dword ptr [edx + ecx*4 + 0x94e2] */
    esp -= 4u; WR32(esp, eax);  /* 0x4d6617: push eax */
    ecx = 0x5cf659u;  /* 0x4d6618: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4d6622u); FL41_CALL(0x4c4b12u); esp += 12u; esp += 4u;  /* 0x4d661d: call 0x4c4b12 */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xcu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d6622: cmp dword ptr [ebp + 0xc], 0 */
    if (!zf) goto L_4d662d;  /* 0x4d6626: jne 0x4d662d */
    goto L_4d66ff;  /* 0x4d6628: jmp 0x4d66ff */
L_4d662d:
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4d662d: mov ecx, dword ptr [ebp + 0xc] */
    WR32((uint32_t)(ebp + 0xfffffff8u), ecx);  /* 0x4d6630: mov dword ptr [ebp - 8], ecx */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffff8u)), b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d6633: cmp dword ptr [ebp - 8], 1 */
    if (zf) goto L_4d6641;  /* 0x4d6637: je 0x4d6641 */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffff8u)), b_ = 0x2u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d6639: cmp dword ptr [ebp - 8], 2 */
    if (zf) goto L_4d6656;  /* 0x4d663d: je 0x4d6656 */
    goto L_4d6669;  /* 0x4d663f: jmp 0x4d6669 */
L_4d6641:
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d6641: mov edx, dword ptr [ebp - 4] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x2b4u)))) & 0xffffffffu;  /* 0x4d6644: movsx eax, word ptr [edx + 0x2b4] */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d664b: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x3390bu), eax);  /* 0x4d664e: mov dword ptr [ecx + 0x3390b], eax */
    goto L_4d6669;  /* 0x4d6654: jmp 0x4d6669 */
L_4d6656:
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d6656: mov edx, dword ptr [ebp - 4] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x2b6u)))) & 0xffffffffu;  /* 0x4d6659: movsx eax, word ptr [edx + 0x2b6] */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d6660: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x3390bu), eax);  /* 0x4d6663: mov dword ptr [ecx + 0x3390b], eax */
L_4d6669:
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4d6669: push 0 */
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4d666b: push 0 */
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4d666d: push 0 */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d666f: mov edx, dword ptr [ebp + 8] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d6672: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + edx * 4u + 0x94e2u));  /* 0x4d6675: mov ecx, dword ptr [eax + edx*4 + 0x94e2] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d667c: push ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d667d: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x3390bu));  /* 0x4d6680: mov eax, dword ptr [edx + 0x3390b] */
    ecx = RD32((uint32_t)(eax * 4u + 0x5d032fu));  /* 0x4d6686: mov ecx, dword ptr [eax*4 + 0x5d032f] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d668d: push ecx */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d668e: mov edx, dword ptr [ebp + 8] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d6691: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + edx * 4u + 0x94e2u));  /* 0x4d6694: mov ecx, dword ptr [eax + edx*4 + 0x94e2] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d669b: mov edx, dword ptr [ebp - 4] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x2bau)))) & 0xffffffffu;  /* 0x4d669e: movsx eax, word ptr [edx + 0x2ba] */
    ecx = RD32((uint32_t)(ecx + 0x41u));  /* 0x4d66a5: mov ecx, dword ptr [ecx + 0x41] */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d66a8: add ecx, eax */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d66aa: push ecx */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d66ab: mov edx, dword ptr [ebp + 8] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d66ae: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + edx * 4u + 0x94e2u));  /* 0x4d66b1: mov ecx, dword ptr [eax + edx*4 + 0x94e2] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d66b8: mov edx, dword ptr [ebp - 4] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x2b8u)))) & 0xffffffffu;  /* 0x4d66bb: movsx eax, word ptr [edx + 0x2b8] */
    ecx = RD32((uint32_t)(ecx + 0x35u));  /* 0x4d66c2: mov ecx, dword ptr [ecx + 0x35] */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d66c5: add ecx, eax */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d66c7: push ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d66c8: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x3390bu));  /* 0x4d66cb: mov eax, dword ptr [edx + 0x3390b] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x1d0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4d66d1: imul eax, eax, 0x1d0 */
    { uint32_t a_ = eax, b_ = 0x5adb3au, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4d66d7: add eax, 0x5adb3a */
    esp -= 4u; WR32(esp, eax);  /* 0x4d66dc: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d66dd: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x3390bu));  /* 0x4d66e0: mov edx, dword ptr [ecx + 0x3390b] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x7f3u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4d66e6: imul edx, edx, 0x7f3 */
    { uint32_t a_ = edx, b_ = 0x5a4c24u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4d66ec: add edx, 0x5a4c24 */
    esp -= 4u; WR32(esp, edx);  /* 0x4d66f2: push edx */
    eax = RD32((uint32_t)(ebp + 0x10u));  /* 0x4d66f3: mov eax, dword ptr [ebp + 0x10] */
    esp -= 4u; WR32(esp, eax);  /* 0x4d66f6: push eax */
    esp -= 4u; WR32(esp, 0x4d66fcu); FL41_CALL(0x4d270bu); esp += 4u;  /* 0x4d66f7: call 0x4d270b */
    { uint32_t a_ = esp, b_ = 0x28u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4d66fc: add esp, 0x28 */
L_4d66ff:
    esp = ebp;  /* 0x4d66ff: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4d6701: pop ebp */
    esp += 16u; goto done;  /* 0x4d6702: ret 0xc */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4d6705 (114 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4d6705_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4d6705: push ebp */
    ebp = esp;  /* 0x4d6706: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x8u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4d6708: sub esp, 8 */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4d670b: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d670e: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x4u));  /* 0x4d6711: mov ecx, dword ptr [eax + 4] */
    WR32((uint32_t)(ebp + 0xfffffff8u), ecx);  /* 0x4d6714: mov dword ptr [ebp - 8], ecx */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffff8u)), b_ = 0x3u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d6717: cmp dword ptr [ebp - 8], 3 */
    if ((!cf && !zf)) goto L_4d6773;  /* 0x4d671b: ja 0x4d6773 */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4d671d: mov edx, dword ptr [ebp - 8] */
    /* 0x4d6720: jmp dword ptr [edx*4 + 0x4d6777] */
    { uint32_t t_ = RD32((uint32_t)(edx * 4u + 0x4d6777u));
    switch (t_) {
    case 0x4d6727u: goto L_4d6727;
    case 0x4d673fu: goto L_4d673f;
    case 0x4d6761u: goto L_4d6761;
    case 0x4d676bu: goto L_4d676b;
    default: FL41_TRAP;
    } }
L_4d6727:
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4d6727: push 0 */
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4d6729: push 0 */
    ecx = 0x5830a6u;  /* 0x4d672b: mov ecx, 0x5830a6 */
    esp -= 4u; WR32(esp, 0x4d6735u); FL41_CALL(0x4dae88u); esp += 8u; esp += 4u;  /* 0x4d6730: call 0x4dae88 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d6735: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4d673du); FL41_CALL(0x4d6787u); esp += 4u;  /* 0x4d6738: call 0x4d6787 */
    goto L_4d6773;  /* 0x4d673d: jmp 0x4d6773 */
L_4d673f:
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(0x5b451fu))) & 0xffffu);  /* 0x4d673f: mov ax, word ptr [0x5b451f] */
    esp -= 4u; WR32(esp, eax);  /* 0x4d6745: push eax */
    esp -= 4u; WR32(esp, 0x5b452du);  /* 0x4d6746: push 0x5b452d */
    ecx = 0x5c3a67u;  /* 0x4d674b: mov ecx, 0x5c3a67 */
    esp -= 4u; WR32(esp, 0x4d6755u); FL41_CALL(0x4fb2a6u); esp += 8u; esp += 4u;  /* 0x4d6750: call 0x4fb2a6 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d6755: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x4u), 0x2u);  /* 0x4d6758: mov dword ptr [ecx + 4], 2 */
    goto L_4d6773;  /* 0x4d675f: jmp 0x4d6773 */
L_4d6761:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d6761: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4d6769u); FL41_CALL(0x4d7162u); esp += 4u;  /* 0x4d6764: call 0x4d7162 */
    goto L_4d6773;  /* 0x4d6769: jmp 0x4d6773 */
L_4d676b:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d676b: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4d6773u); FL41_CALL(0x4d794du); esp += 4u;  /* 0x4d676e: call 0x4d794d */
L_4d6773:
    esp = ebp;  /* 0x4d6773: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4d6775: pop ebp */
    esp += 4u; goto done;  /* 0x4d6776: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4d912a (226 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4d912a_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4d912a: push ebp */
    ebp = esp;  /* 0x4d912b: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d912d: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4d912e: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d9131: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = 0x2afu, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4d9134: add eax, 0x2af */
    esp -= 4u; WR32(esp, eax);  /* 0x4d9139: push eax */
    esp -= 4u; WR32(esp, 0x55a9a8u);  /* 0x4d913a: push 0x55a9a8 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d913f: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x333e3u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d9142: add ecx, 0x333e3 */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d9148: push ecx */
    esp -= 4u; WR32(esp, 0x4d914eu); FL41_CALL(0x50ca3eu); esp += 4u;  /* 0x4d9149: call 0x50ca3e */
    { uint32_t a_ = esp, b_ = 0xcu, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4d914e: add esp, 0xc */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d9151: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x333e3u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4d9154: add edx, 0x333e3 */
    esp -= 4u; WR32(esp, edx);  /* 0x4d915a: push edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d915b: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = 0x2a5u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4d915e: add eax, 0x2a5 */
    esp -= 4u; WR32(esp, eax);  /* 0x4d9163: push eax */
    esp -= 4u; WR32(esp, 0x63a3c9u);  /* 0x4d9164: push 0x63a3c9 */
    esp -= 4u; WR32(esp, 0x63a9b8u);  /* 0x4d9169: push 0x63a9b8 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4d916e: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4d9178u); FL41_CALL(0x50cd72u); esp += 4u;  /* 0x4d9173: call 0x50cd72 */
    { uint32_t a_ = esp, b_ = 0x14u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4d9178: add esp, 0x14 */
    esp -= 4u; WR32(esp, 0x55a9acu);  /* 0x4d917b: push 0x55a9ac */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4d9180: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4d918au); FL41_CALL(0x50d0a9u); esp += 4u;  /* 0x4d9185: call 0x50d0a9 */
    { uint32_t a_ = esp, b_ = 0x8u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4d918a: add esp, 8 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d918d: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x98acu), eax);  /* 0x4d9190: mov dword ptr [ecx + 0x98ac], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d9196: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(edx + 0x98acu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d9199: cmp dword ptr [edx + 0x98ac], 0 */
    if (!zf) goto L_4d91a7;  /* 0x4d91a0: jne 0x4d91a7 */
    { uint32_t a_ = (eax & 0xffffu), b_ = (eax & 0xffffu), r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 16); eax = (eax & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4d91a2: xor ax, ax */
    goto L_4d9208;  /* 0x4d91a5: jmp 0x4d9208 */
L_4d91a7:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d91a7: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x98acu));  /* 0x4d91aa: mov ecx, dword ptr [eax + 0x98ac] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d91b0: push ecx */
    esp -= 4u; WR32(esp, 0x1u);  /* 0x4d91b1: push 1 */
    esp -= 4u; WR32(esp, 0x905cu);  /* 0x4d91b3: push 0x905c */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d91b8: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x476u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4d91bb: add edx, 0x476 */
    esp -= 4u; WR32(esp, edx);  /* 0x4d91c1: push edx */
    esp -= 4u; WR32(esp, 0x4d91c7u); FL41_CALL(0x50cf61u); esp += 4u;  /* 0x4d91c2: call 0x50cf61 */
    { uint32_t a_ = esp, b_ = 0x10u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4d91c7: add esp, 0x10 */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d91ca: cmp eax, 1 */
    if (zf) goto L_4d91f2;  /* 0x4d91cd: je 0x4d91f2 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4d91cf: push 0x63888b */
    esp -= 4u; WR32(esp, 0x55a9b0u);  /* 0x4d91d4: push 0x55a9b0 */
    ecx = 0x583979u;  /* 0x4d91d9: mov ecx, 0x583979 */
    esp -= 4u; WR32(esp, 0x4d91e3u); FL41_CALL(0x42639du); esp += 8u; esp += 4u;  /* 0x4d91de: call 0x42639d */
    ecx = 0x5cf659u;  /* 0x4d91e3: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4d91edu); FL41_CALL(0x4c97b4u); esp += 4u;  /* 0x4d91e8: call 0x4c97b4 */
    { uint32_t a_ = (eax & 0xffffu), b_ = (eax & 0xffffu), r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 16); eax = (eax & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4d91ed: xor ax, ax */
    goto L_4d9208;  /* 0x4d91f0: jmp 0x4d9208 */
L_4d91f2:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d91f2: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x98acu));  /* 0x4d91f5: mov ecx, dword ptr [eax + 0x98ac] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d91fb: push ecx */
    esp -= 4u; WR32(esp, 0x4d9201u); FL41_CALL(0x50cee4u); esp += 4u;  /* 0x4d91fc: call 0x50cee4 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4d9201: add esp, 4 */
    eax = (eax & 0xffff0000u) | ((0x1u) & 0xffffu);  /* 0x4d9204: mov ax, 1 */
L_4d9208:
    esp = ebp;  /* 0x4d9208: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4d920a: pop ebp */
    esp += 4u; goto done;  /* 0x4d920b: ret  */
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

/* GAME.EXE 0x4dbb13 (340 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4dbb13_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4dbb13: push ebp */
    ebp = esp;  /* 0x4dbb14: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x8u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4dbb16: sub esp, 8 */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4dbb19: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(0x583204u));  /* 0x4dbb1c: mov eax, dword ptr [0x583204] */
    WR32((uint32_t)(ebp + 0xfffffff8u), eax);  /* 0x4dbb21: mov dword ptr [ebp - 8], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4dbb24: mov ecx, dword ptr [ebp - 8] */
    { uint32_t a_ = ecx, b_ = 0x2u, r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4dbb27: sub ecx, 2 */
    WR32((uint32_t)(ebp + 0xfffffff8u), ecx);  /* 0x4dbb2a: mov dword ptr [ebp - 8], ecx */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffff8u)), b_ = 0x3u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4dbb2d: cmp dword ptr [ebp - 8], 3 */
    if ((!cf && !zf)) goto L_4dbb3d;  /* 0x4dbb31: ja 0x4dbb3d */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4dbb33: mov edx, dword ptr [ebp - 8] */
    /* 0x4dbb36: jmp dword ptr [edx*4 + 0x4dbc67] */
    { uint32_t t_ = RD32((uint32_t)(edx * 4u + 0x4dbc67u));
    switch (t_) {
    case 0x4dbc01u: goto L_4dbc01;
    case 0x4dbc14u: goto L_4dbc14;
    case 0x4dbc27u: goto L_4dbc27;
    case 0x4dbc3au: goto L_4dbc3a;
    default: FL41_TRAP;
    } }
L_4dbb3d:
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x63988bu)))) & 0xffffffffu;  /* 0x4dbb3d: movsx eax, word ptr [0x63988b] */
    ecx = RD32((uint32_t)(0x5b44f4u));  /* 0x4dbb44: mov ecx, dword ptr [0x5b44f4] */
    { uint32_t a_ = ecx, n_ = 0x2u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); ecx = r_; } }  /* 0x4dbb4a: shl ecx, 2 */
    edx = RD32((uint32_t)(0x5b44f0u));  /* 0x4dbb4d: mov edx, dword ptr [0x5b44f0] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + edx * 8u + 0x5b3790u)))) & 0xffffffffu;  /* 0x4dbb53: movsx ecx, word ptr [ecx + edx*8 + 0x5b3790] */
    { uint32_t a_ = eax, b_ = ecx, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4dbb5b: sub eax, ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4dbb5d: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(edx + 0x14u)), b_ = eax, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4dbb60: cmp dword ptr [edx + 0x14], eax */
    if ((sf != of)) goto L_4dbb8b;  /* 0x4dbb63: jl 0x4dbb8b */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x63988bu)))) & 0xffffffffu;  /* 0x4dbb65: movsx eax, word ptr [0x63988b] */
    ecx = RD32((uint32_t)(0x5b44f4u));  /* 0x4dbb6c: mov ecx, dword ptr [0x5b44f4] */
    { uint32_t a_ = ecx, n_ = 0x2u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); ecx = r_; } }  /* 0x4dbb72: shl ecx, 2 */
    edx = RD32((uint32_t)(0x5b44f0u));  /* 0x4dbb75: mov edx, dword ptr [0x5b44f0] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + edx * 8u + 0x5b3790u)))) & 0xffffffffu;  /* 0x4dbb7b: movsx ecx, word ptr [ecx + edx*8 + 0x5b3790] */
    { uint32_t a_ = eax, b_ = ecx, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4dbb83: sub eax, ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4dbb85: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x14u), eax);  /* 0x4dbb88: mov dword ptr [edx + 0x14], eax */
L_4dbb8b:
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x63988du)))) & 0xffffffffu;  /* 0x4dbb8b: movsx eax, word ptr [0x63988d] */
    ecx = RD32((uint32_t)(0x5b44f4u));  /* 0x4dbb92: mov ecx, dword ptr [0x5b44f4] */
    { uint32_t a_ = ecx, n_ = 0x2u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); ecx = r_; } }  /* 0x4dbb98: shl ecx, 2 */
    edx = RD32((uint32_t)(0x5b44f0u));  /* 0x4dbb9b: mov edx, dword ptr [0x5b44f0] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + edx * 8u + 0x5b3792u)))) & 0xffffffffu;  /* 0x4dbba1: movsx ecx, word ptr [ecx + edx*8 + 0x5b3792] */
    { uint32_t a_ = eax, b_ = ecx, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4dbba9: sub eax, ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4dbbab: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(edx + 0x18u)), b_ = eax, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4dbbae: cmp dword ptr [edx + 0x18], eax */
    if ((sf != of)) goto L_4dbbd9;  /* 0x4dbbb1: jl 0x4dbbd9 */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x63988du)))) & 0xffffffffu;  /* 0x4dbbb3: movsx eax, word ptr [0x63988d] */
    ecx = RD32((uint32_t)(0x5b44f4u));  /* 0x4dbbba: mov ecx, dword ptr [0x5b44f4] */
    { uint32_t a_ = ecx, n_ = 0x2u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); ecx = r_; } }  /* 0x4dbbc0: shl ecx, 2 */
    edx = RD32((uint32_t)(0x5b44f0u));  /* 0x4dbbc3: mov edx, dword ptr [0x5b44f0] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + edx * 8u + 0x5b3792u)))) & 0xffffffffu;  /* 0x4dbbc9: movsx ecx, word ptr [ecx + edx*8 + 0x5b3792] */
    { uint32_t a_ = eax, b_ = ecx, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4dbbd1: sub eax, ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4dbbd3: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x18u), eax);  /* 0x4dbbd6: mov dword ptr [edx + 0x18], eax */
L_4dbbd9:
    { uint32_t a_ = RD32((uint32_t)(0x5c39e9u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4dbbd9: cmp dword ptr [0x5c39e9], 0 */
    if (zf) goto L_4dbbff;  /* 0x4dbbe0: je 0x4dbbff */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4dbbe2: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x18u));  /* 0x4dbbe5: mov ecx, dword ptr [eax + 0x18] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x5b3788u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4dbbe8: cmp ecx, dword ptr [0x5b3788] */
    if ((!zf && sf == of)) goto L_4dbbff;  /* 0x4dbbee: jg 0x4dbbff */
    edx = RD32((uint32_t)(0x5b3788u));  /* 0x4dbbf0: mov edx, dword ptr [0x5b3788] */
    { uint32_t a_ = edx, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4dbbf6: add edx, 1 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4dbbf9: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x18u), edx);  /* 0x4dbbfc: mov dword ptr [eax + 0x18], edx */
L_4dbbff:
    goto L_4dbc4b;  /* 0x4dbbff: jmp 0x4dbc4b */
L_4dbc01:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4dbc01: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x14u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4dbc04: add ecx, 0x14 */
    esp -= 4u; WR32(esp, ecx);  /* 0x4dbc07: push ecx */
    ecx = 0x582711u;  /* 0x4dbc08: mov ecx, 0x582711 */
    esp -= 4u; WR32(esp, 0x4dbc12u); FL41_CALL(0x4e779fu); esp += 4u; esp += 4u;  /* 0x4dbc0d: call 0x4e779f */
    goto L_4dbc4b;  /* 0x4dbc12: jmp 0x4dbc4b */
L_4dbc14:
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4dbc14: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x14u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4dbc17: add edx, 0x14 */
    esp -= 4u; WR32(esp, edx);  /* 0x4dbc1a: push edx */
    ecx = 0x571442u;  /* 0x4dbc1b: mov ecx, 0x571442 */
    esp -= 4u; WR32(esp, 0x4dbc25u); FL41_CALL(0x4e89d2u); esp += 4u; esp += 4u;  /* 0x4dbc20: call 0x4e89d2 */
    goto L_4dbc4b;  /* 0x4dbc25: jmp 0x4dbc4b */
L_4dbc27:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4dbc27: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = 0x14u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4dbc2a: add eax, 0x14 */
    esp -= 4u; WR32(esp, eax);  /* 0x4dbc2d: push eax */
    ecx = 0x57fd34u;  /* 0x4dbc2e: mov ecx, 0x57fd34 */
    esp -= 4u; WR32(esp, 0x4dbc38u); FL41_CALL(0x4ebd6cu); esp += 4u; esp += 4u;  /* 0x4dbc33: call 0x4ebd6c */
    goto L_4dbc4b;  /* 0x4dbc38: jmp 0x4dbc4b */
L_4dbc3a:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4dbc3a: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x14u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4dbc3d: add ecx, 0x14 */
    esp -= 4u; WR32(esp, ecx);  /* 0x4dbc40: push ecx */
    ecx = 0x57975cu;  /* 0x4dbc41: mov ecx, 0x57975c */
    esp -= 4u; WR32(esp, 0x4dbc4bu); FL41_CALL(0x4e4114u); esp += 4u; esp += 4u;  /* 0x4dbc46: call 0x4e4114 */
L_4dbc4b:
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4dbc4b: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x18u));  /* 0x4dbc4e: mov eax, dword ptr [edx + 0x18] */
    esp -= 4u; WR32(esp, eax);  /* 0x4dbc51: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4dbc52: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x14u));  /* 0x4dbc55: mov edx, dword ptr [ecx + 0x14] */
    esp -= 4u; WR32(esp, edx);  /* 0x4dbc58: push edx */
    ecx = 0x5830a6u;  /* 0x4dbc59: mov ecx, 0x5830a6 */
    esp -= 4u; WR32(esp, 0x4dbc63u); FL41_CALL(0x4dae88u); esp += 8u; esp += 4u;  /* 0x4dbc5e: call 0x4dae88 */
    esp = ebp;  /* 0x4dbc63: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4dbc65: pop ebp */
    esp += 4u; goto done;  /* 0x4dbc66: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4de24f (137 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4de24f_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4de24f: push ebp */
    ebp = esp;  /* 0x4de250: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4de252: push ecx */
    esp -= 4u; WR32(esp, edi);  /* 0x4de253: push edi */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4de254: mov dword ptr [ebp - 4], ecx */
    edi = RD32((uint32_t)(ebp + 0xcu));  /* 0x4de257: mov edi, dword ptr [ebp + 0xc] */
    { uint32_t a_ = ecx, b_ = 0xffffffffu, r_; r_ = a_ | b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x4de25a: or ecx, 0xffffffff */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4de25d: xor eax, eax */
    /* 0x4de25f: repne scasb al, byte ptr es:[edi] */
    while (ecx != 0u) {
    { uint32_t a_ = eax & 0xffu, b_ = RD8(edi), r_;
    FL41_SUB(a_, b_, 0u, r_, 8); }
    edi += 1u;
    ecx -= 1u;
    if (zf) break;
    }
    { uint32_t a_ = ecx; ecx = (~a_) & 0xffffffffu; }  /* 0x4de261: not ecx */
    { uint32_t a_ = ecx, b_ = 0xffffffffu, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4de263: add ecx, -1 */
    { uint32_t a_ = ecx, b_ = ecx, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4de266: test ecx, ecx */
    if ((cf || zf)) goto L_4de283;  /* 0x4de268: jbe 0x4de283 */
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4de26a: push 0 */
    esp -= 4u; WR32(esp, 0xfffffffeu);  /* 0x4de26c: push -2 */
    eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x4de26e: mov eax, dword ptr [ebp + 0xc] */
    esp -= 4u; WR32(esp, eax);  /* 0x4de271: push eax */
    ecx = RD32((uint32_t)(0x5d03afu));  /* 0x4de272: mov ecx, dword ptr [0x5d03af] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4de278: push ecx */
    ecx = 0x619a05u;  /* 0x4de279: mov ecx, 0x619a05 */
    esp -= 4u; WR32(esp, 0x4de283u); FL41_CALL(0x448d11u); esp += 16u; esp += 4u;  /* 0x4de27e: call 0x448d11 */
L_4de283:
    WR32((uint32_t)(0x5b15d6u), 0x1u);  /* 0x4de283: mov dword ptr [0x5b15d6], 1 */
    WR32((uint32_t)(0x5d17f5u), 0x1u);  /* 0x4de28d: mov dword ptr [0x5d17f5], 1 */
    WR8((uint32_t)(0x5a161fu), 0x1u);  /* 0x4de297: mov byte ptr [0x5a161f], 1 */
    esp -= 4u; WR32(esp, 0x4de2a3u); FL41_CALL(0x43dbd5u); esp += 4u;  /* 0x4de29e: call 0x43dbd5 */
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4de2a3: push 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4de2a5: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4de2adu); FL41_CALL(0x4ee673u); esp += 4u; esp += 4u;  /* 0x4de2a8: call 0x4ee673 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4de2ad: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4de2b0: mov eax, dword ptr [ebp + 8] */
    WR32((uint32_t)(edx + 0x991u), eax);  /* 0x4de2b3: mov dword ptr [edx + 0x991], eax */
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4de2b9: mov ecx, dword ptr [ebp + 8] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4de2bc: push ecx */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4de2bd: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4de2c5u); FL41_CALL(0x4edf96u); esp += 4u; esp += 4u;  /* 0x4de2c0: call 0x4edf96 */
    esp -= 4u; WR32(esp, 0x2u);  /* 0x4de2c5: push 2 */
    ecx = 0x570508u;  /* 0x4de2c7: mov ecx, 0x570508 */
    esp -= 4u; WR32(esp, 0x4de2d1u); FL41_CALL(0x4e053fu); esp += 4u; esp += 4u;  /* 0x4de2cc: call 0x4e053f */
    edi = RD32(esp); esp += 4u;  /* 0x4de2d1: pop edi */
    esp = ebp;  /* 0x4de2d2: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4de2d4: pop ebp */
    esp += 12u; goto done;  /* 0x4de2d5: ret 8 */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4de322 (114 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4de322_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4de322: push ebp */
    ebp = esp;  /* 0x4de323: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x24u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4de325: sub esp, 0x24 */
    WR32((uint32_t)(ebp + 0xffffffdcu), ecx);  /* 0x4de328: mov dword ptr [ebp - 0x24], ecx */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4de32b: mov eax, dword ptr [ebp - 0x24] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x991u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4de32e: cmp dword ptr [eax + 0x991], 0 */
    if (zf) goto L_4de343;  /* 0x4de335: je 0x4de343 */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4de337: mov ecx, dword ptr [ebp - 0x24] */
    { uint32_t a_ = RD32((uint32_t)(ecx + 0x991u)), b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4de33a: cmp dword ptr [ecx + 0x991], 1 */
    if (!zf) goto L_4de345;  /* 0x4de341: jne 0x4de345 */
L_4de343:
    goto L_4de390;  /* 0x4de343: jmp 0x4de390 */
L_4de345:
    edx = (uint32_t)(ebp + 0xffffffe0u);  /* 0x4de345: lea edx, [ebp - 0x20] */
    esp -= 4u; WR32(esp, edx);  /* 0x4de348: push edx */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4de349: mov ecx, dword ptr [ebp - 0x24] */
    esp -= 4u; WR32(esp, 0x4de351u); FL41_CALL(0x4ee644u); esp += 4u; esp += 4u;  /* 0x4de34c: call 0x4ee644 */
    ecx = RD32((uint32_t)(eax));  /* 0x4de351: mov ecx, dword ptr [eax] */
    WR32((uint32_t)(ebp + 0xfffffff0u), ecx);  /* 0x4de353: mov dword ptr [ebp - 0x10], ecx */
    edx = RD32((uint32_t)(eax + 0x4u));  /* 0x4de356: mov edx, dword ptr [eax + 4] */
    WR32((uint32_t)(ebp + 0xfffffff4u), edx);  /* 0x4de359: mov dword ptr [ebp - 0xc], edx */
    ecx = RD32((uint32_t)(eax + 0x8u));  /* 0x4de35c: mov ecx, dword ptr [eax + 8] */
    WR32((uint32_t)(ebp + 0xfffffff8u), ecx);  /* 0x4de35f: mov dword ptr [ebp - 8], ecx */
    edx = RD32((uint32_t)(eax + 0xcu));  /* 0x4de362: mov edx, dword ptr [eax + 0xc] */
    WR32((uint32_t)(ebp + 0xfffffffcu), edx);  /* 0x4de365: mov dword ptr [ebp - 4], edx */
    { uint32_t a_ = RD32((uint32_t)(0x5839a9u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4de368: cmp dword ptr [0x5839a9], 0 */
    if (!zf) goto L_4de390;  /* 0x4de36f: jne 0x4de390 */
    eax = (uint32_t)(ebp + 0xfffffff0u);  /* 0x4de371: lea eax, [ebp - 0x10] */
    esp -= 4u; WR32(esp, eax);  /* 0x4de374: push eax */
    esp -= 4u; WR32(esp, 0x583102u);  /* 0x4de375: push 0x583102 */
    ecx = 0x570450u;  /* 0x4de37a: mov ecx, 0x570450 */
    esp -= 4u; WR32(esp, 0x4de384u); FL41_CALL(0x4d57e8u); esp += 8u; esp += 4u;  /* 0x4de37f: call 0x4d57e8 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4de384: test eax, eax */
    if (zf) goto L_4de390;  /* 0x4de386: je 0x4de390 */
    ecx = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x4de388: mov ecx, dword ptr [ebp - 0x24] */
    esp -= 4u; WR32(esp, 0x4de390u); FL41_CALL(0x4ee2a9u); esp += 4u;  /* 0x4de38b: call 0x4ee2a9 */
L_4de390:
    esp = ebp;  /* 0x4de390: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4de392: pop ebp */
    esp += 4u; goto done;  /* 0x4de393: ret  */
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

/* GAME.EXE 0x4e2b99 (271 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4e2b99_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4e2b99: push ebp */
    ebp = esp;  /* 0x4e2b9a: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4e2b9c: push ecx */
    esp -= 4u; WR32(esp, esi);  /* 0x4e2b9d: push esi */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4e2b9e: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2ba1: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x30u)), b_ = 0x4u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e2ba4: cmp dword ptr [eax + 0x30], 4 */
    if (!zf) goto L_4e2baf;  /* 0x4e2ba8: jne 0x4e2baf */
    goto L_4e2ca3;  /* 0x4e2baa: jmp 0x4e2ca3 */
L_4e2baf:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2baf: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(ecx + 0x34u)), b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e2bb2: cmp dword ptr [ecx + 0x34], 1 */
    if (zf) goto L_4e2bc4;  /* 0x4e2bb6: je 0x4e2bc4 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2bb8: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(edx + 0x177u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e2bbb: cmp dword ptr [edx + 0x177], 0 */
    if (zf) goto L_4e2bfe;  /* 0x4e2bc2: je 0x4e2bfe */
L_4e2bc4:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2bc4: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x177u), 0x0u);  /* 0x4e2bc7: mov dword ptr [eax + 0x177], 0 */
    esp -= 4u; WR32(esp, 0x55bfb8u);  /* 0x4e2bd1: push 0x55bfb8 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2bd6: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4e2bd9: add ecx, 4 */
    esp -= 4u; WR32(esp, ecx);  /* 0x4e2bdc: push ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2bdd: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0xbeu, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4e2be0: add edx, 0xbe */
    esp -= 4u; WR32(esp, edx);  /* 0x4e2be6: push edx */
    eax = RD32((uint32_t)(0x5cf665u));  /* 0x4e2be7: mov eax, dword ptr [0x5cf665] */
    esp -= 4u; WR32(esp, eax);  /* 0x4e2bec: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2bed: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x28u));  /* 0x4e2bf0: mov edx, dword ptr [ecx + 0x28] */
    esp -= 4u; WR32(esp, edx);  /* 0x4e2bf3: push edx */
    ecx = 0x5cf659u;  /* 0x4e2bf4: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4e2bfeu); FL41_CALL(0x4c5377u); esp += 20u; esp += 4u;  /* 0x4e2bf9: call 0x4c5377 */
L_4e2bfe:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2bfe: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x30u));  /* 0x4e2c01: mov ecx, dword ptr [eax + 0x30] */
    { uint32_t a_ = ecx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); ecx = r_; } }  /* 0x4e2c04: shl ecx, 4 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2c07: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x30u));  /* 0x4e2c0a: mov eax, dword ptr [edx + 0x30] */
    { uint32_t a_ = eax, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); eax = r_; } }  /* 0x4e2c0d: shl eax, 4 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2c10: mov edx, dword ptr [ebp - 4] */
    esi = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2c13: mov esi, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(edx + ecx + 0x133u));  /* 0x4e2c16: mov ecx, dword ptr [edx + ecx + 0x133] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(esi + eax + 0x12bu)), r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4e2c1d: sub ecx, dword ptr [esi + eax + 0x12b] */
    { uint32_t a_ = ecx, b_ = ecx, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4e2c24: test ecx, ecx */
    if (zf) goto L_4e2ca3;  /* 0x4e2c26: je 0x4e2ca3 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2c28: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(edx + 0x34u)), b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e2c2b: cmp dword ptr [edx + 0x34], 1 */
    if (!zf) goto L_4e2c6b;  /* 0x4e2c2f: jne 0x4e2c6b */
    esp -= 4u; WR32(esp, 0x55bfccu);  /* 0x4e2c31: push 0x55bfcc */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2c36: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4e2c39: add eax, 4 */
    esp -= 4u; WR32(esp, eax);  /* 0x4e2c3c: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2c3d: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x30u));  /* 0x4e2c40: mov edx, dword ptr [ecx + 0x30] */
    { uint32_t a_ = edx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); edx = r_; } }  /* 0x4e2c43: shl edx, 4 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2c46: mov eax, dword ptr [ebp - 4] */
    ecx = (uint32_t)(eax + edx + 0x127u);  /* 0x4e2c49: lea ecx, [eax + edx + 0x127] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4e2c50: push ecx */
    edx = RD32((uint32_t)(0x5cf665u));  /* 0x4e2c51: mov edx, dword ptr [0x5cf665] */
    esp -= 4u; WR32(esp, edx);  /* 0x4e2c57: push edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2c58: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x24u));  /* 0x4e2c5b: mov ecx, dword ptr [eax + 0x24] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4e2c5e: push ecx */
    ecx = 0x5cf659u;  /* 0x4e2c5f: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4e2c69u); FL41_CALL(0x4c5d4bu); esp += 20u; esp += 4u;  /* 0x4e2c64: call 0x4c5d4b */
    goto L_4e2ca3;  /* 0x4e2c69: jmp 0x4e2ca3 */
L_4e2c6b:
    esp -= 4u; WR32(esp, 0x55bfecu);  /* 0x4e2c6b: push 0x55bfec */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2c70: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4e2c73: add edx, 4 */
    esp -= 4u; WR32(esp, edx);  /* 0x4e2c76: push edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2c77: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x30u));  /* 0x4e2c7a: mov ecx, dword ptr [eax + 0x30] */
    { uint32_t a_ = ecx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); ecx = r_; } }  /* 0x4e2c7d: shl ecx, 4 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2c80: mov edx, dword ptr [ebp - 4] */
    eax = (uint32_t)(edx + ecx + 0x127u);  /* 0x4e2c83: lea eax, [edx + ecx + 0x127] */
    esp -= 4u; WR32(esp, eax);  /* 0x4e2c8a: push eax */
    ecx = RD32((uint32_t)(0x5cf665u));  /* 0x4e2c8b: mov ecx, dword ptr [0x5cf665] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4e2c91: push ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e2c92: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x24u));  /* 0x4e2c95: mov eax, dword ptr [edx + 0x24] */
    esp -= 4u; WR32(esp, eax);  /* 0x4e2c98: push eax */
    ecx = 0x5cf659u;  /* 0x4e2c99: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4e2ca3u); FL41_CALL(0x4c5377u); esp += 20u; esp += 4u;  /* 0x4e2c9e: call 0x4c5377 */
L_4e2ca3:
    esi = RD32(esp); esp += 4u;  /* 0x4e2ca3: pop esi */
    esp = ebp;  /* 0x4e2ca4: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4e2ca6: pop ebp */
    esp += 4u; goto done;  /* 0x4e2ca7: ret  */
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

/* GAME.EXE 0x4e3093 (1170 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4e3093_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4e3093: push ebp */
    ebp = esp;  /* 0x4e3094: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0xfcu, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4e3096: sub esp, 0xfc */
    esp -= 4u; WR32(esp, esi);  /* 0x4e309c: push esi */
    esp -= 4u; WR32(esp, edi);  /* 0x4e309d: push edi */
    WR32((uint32_t)(ebp + 0xffffff04u), ecx);  /* 0x4e309e: mov dword ptr [ebp - 0xfc], ecx */
    ecx = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e30a4: mov ecx, dword ptr [ebp - 0xfc] */
    esp -= 4u; WR32(esp, 0x4e30afu); FL41_CALL(0x4ee572u); esp += 4u;  /* 0x4e30aa: call 0x4ee572 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4e30af: test eax, eax */
    if (zf) goto L_4e3107;  /* 0x4e30b1: je 0x4e3107 */
    ecx = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e30b3: mov ecx, dword ptr [ebp - 0xfc] */
    esp -= 4u; WR32(esp, 0x4e30beu); FL41_CALL(0x4ee5f2u); esp += 4u;  /* 0x4e30b9: call 0x4ee5f2 */
    esp -= 4u; WR32(esp, eax);  /* 0x4e30be: push eax */
    esp -= 4u; WR32(esp, 0x55c000u);  /* 0x4e30bf: push 0x55c000 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4e30c4: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4e30ceu); FL41_CALL(0x50ca3eu); esp += 4u;  /* 0x4e30c9: call 0x50ca3e */
    { uint32_t a_ = esp, b_ = 0xcu, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4e30ce: add esp, 0xc */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4e30d1: push 0x63888b */
    ecx = 0x583979u;  /* 0x4e30d6: mov ecx, 0x583979 */
    esp -= 4u; WR32(esp, 0x4e30e0u); FL41_CALL(0x4264e8u); esp += 4u; esp += 4u;  /* 0x4e30db: call 0x4264e8 */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x63a4cdu)))) & 0xffffffffu;  /* 0x4e30e0: movsx eax, word ptr [0x63a4cd] */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4e30e7: test eax, eax */
    if (zf) goto L_4e30f8;  /* 0x4e30e9: je 0x4e30f8 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4e30eb: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4e30f5u); FL41_CALL(0x44a2b7u); esp += 4u;  /* 0x4e30f0: call 0x44a2b7 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4e30f5: add esp, 4 */
L_4e30f8:
    ecx = 0x5cf659u;  /* 0x4e30f8: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4e3102u); FL41_CALL(0x4c97b4u); esp += 4u;  /* 0x4e30fd: call 0x4c97b4 */
    goto L_4e351f;  /* 0x4e3102: jmp 0x4e351f */
L_4e3107:
    esp -= 4u; WR32(esp, 0x1u);  /* 0x4e3107: push 1 */
    ecx = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e3109: mov ecx, dword ptr [ebp - 0xfc] */
    { uint32_t a_ = ecx, b_ = 0x6d2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4e310f: add ecx, 0x6d2 */
    esp -= 4u; WR32(esp, ecx);  /* 0x4e3115: push ecx */
    ecx = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e3116: mov ecx, dword ptr [ebp - 0xfc] */
    esp -= 4u; WR32(esp, 0x4e3121u); FL41_CALL(0x4edcb1u); esp += 8u; esp += 4u;  /* 0x4e311c: call 0x4edcb1 */
    esp -= 4u; WR32(esp, 0x1u);  /* 0x4e3121: push 1 */
    ecx = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e3123: mov ecx, dword ptr [ebp - 0xfc] */
    esp -= 4u; WR32(esp, 0x4e312eu); FL41_CALL(0x4ee6c7u); esp += 4u; esp += 4u;  /* 0x4e3129: call 0x4ee6c7 */
    esp -= 4u; WR32(esp, 0x55c04cu);  /* 0x4e312e: push 0x55c04c */
    esp -= 4u; WR32(esp, 0x6u);  /* 0x4e3133: push 6 */
    edx = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e3135: mov edx, dword ptr [ebp - 0xfc] */
    { uint32_t a_ = edx, b_ = 0x9c2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4e313b: add edx, 0x9c2 */
    esp -= 4u; WR32(esp, edx);  /* 0x4e3141: push edx */
    esp -= 4u; WR32(esp, 0x55c064u);  /* 0x4e3142: push 0x55c064 */
    ecx = 0x5cf659u;  /* 0x4e3147: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4e3151u); FL41_CALL(0x4c2790u); esp += 16u; esp += 4u;  /* 0x4e314c: call 0x4c2790 */
    ecx = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e3151: mov ecx, dword ptr [ebp - 0xfc] */
    WR32((uint32_t)(ecx + 0x6ceu), eax);  /* 0x4e3157: mov dword ptr [ecx + 0x6ce], eax */
    esi = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e315d: mov esi, dword ptr [ebp - 0xfc] */
    { uint32_t a_ = esi, b_ = 0x9c2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esi = r_; }  /* 0x4e3163: add esi, 0x9c2 */
    ecx = 0x3bu;  /* 0x4e3169: mov ecx, 0x3b */
    edi = (uint32_t)(ebp + 0xffffff0cu);  /* 0x4e316e: lea edi, [ebp - 0xf4] */
    /* 0x4e3174: rep movsd dword ptr es:[edi], dword ptr [esi] */
    while (ecx != 0u) {
    WR32(edi, RD32(esi));
    esi += 4u; edi += 4u;
    ecx -= 1u;
    }
    WR16(edi, RD16(esi)); esi += 2u; edi += 2u;  /* 0x4e3176: movsw word ptr es:[edi], word ptr [esi] */
    WR8(edi, RD8(esi)); esi += 1u; edi += 1u;  /* 0x4e3178: movsb byte ptr es:[edi], byte ptr [esi] */
    WR16((uint32_t)(ebp + 0xfffffffcu), 0x0u);  /* 0x4e3179: mov word ptr [ebp - 4], 0 */
    goto L_4e318d;  /* 0x4e317f: jmp 0x4e318d */
L_4e3181:
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffffcu))) & 0xffffu);  /* 0x4e3181: mov dx, word ptr [ebp - 4] */
    { uint32_t a_ = (edx & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); edx = (edx & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4e3185: add dx, 1 */
    WR16((uint32_t)(ebp + 0xfffffffcu), (edx & 0xffffu));  /* 0x4e3189: mov word ptr [ebp - 4], dx */
L_4e318d:
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4e318d: movsx eax, word ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = 0xfu, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e3191: cmp eax, 0xf */
    if ((sf == of)) goto L_4e3292;  /* 0x4e3194: jge 0x4e3292 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4e319a: movsx ecx, word ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x41u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4e319e: imul ecx, ecx, 0x41 */
    edx = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e31a1: mov edx, dword ptr [ebp - 0xfc] */
    eax = (uint32_t)(edx + ecx + 0xab1u);  /* 0x4e31a7: lea eax, [edx + ecx + 0xab1] */
    ecx = RD32((uint32_t)(eax));  /* 0x4e31ae: mov ecx, dword ptr [eax] */
    WR32((uint32_t)(ebp + 0xffffff72u), ecx);  /* 0x4e31b0: mov dword ptr [ebp - 0x8e], ecx */
    edx = RD32((uint32_t)(eax + 0x4u));  /* 0x4e31b6: mov edx, dword ptr [eax + 4] */
    WR32((uint32_t)(ebp + 0xffffff76u), edx);  /* 0x4e31b9: mov dword ptr [ebp - 0x8a], edx */
    ecx = RD32((uint32_t)(eax + 0x8u));  /* 0x4e31bf: mov ecx, dword ptr [eax + 8] */
    WR32((uint32_t)(ebp + 0xffffff7au), ecx);  /* 0x4e31c2: mov dword ptr [ebp - 0x86], ecx */
    edx = RD32((uint32_t)(eax + 0xcu));  /* 0x4e31c8: mov edx, dword ptr [eax + 0xc] */
    WR32((uint32_t)(ebp + 0xffffff7eu), edx);  /* 0x4e31cb: mov dword ptr [ebp - 0x82], edx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4e31d1: movsx eax, word ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x41u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4e31d5: imul eax, eax, 0x41 */
    ecx = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e31d8: mov ecx, dword ptr [ebp - 0xfc] */
    edx = (uint32_t)(ecx + eax + 0xac1u);  /* 0x4e31de: lea edx, [ecx + eax + 0xac1] */
    eax = RD32((uint32_t)(edx));  /* 0x4e31e5: mov eax, dword ptr [edx] */
    WR32((uint32_t)(ebp + 0xffffffa2u), eax);  /* 0x4e31e7: mov dword ptr [ebp - 0x5e], eax */
    ecx = RD32((uint32_t)(edx + 0x4u));  /* 0x4e31ea: mov ecx, dword ptr [edx + 4] */
    WR32((uint32_t)(ebp + 0xffffffa6u), ecx);  /* 0x4e31ed: mov dword ptr [ebp - 0x5a], ecx */
    eax = RD32((uint32_t)(edx + 0x8u));  /* 0x4e31f0: mov eax, dword ptr [edx + 8] */
    WR32((uint32_t)(ebp + 0xffffffaau), eax);  /* 0x4e31f3: mov dword ptr [ebp - 0x56], eax */
    ecx = RD32((uint32_t)(edx + 0xcu));  /* 0x4e31f6: mov ecx, dword ptr [edx + 0xc] */
    WR32((uint32_t)(ebp + 0xffffffaeu), ecx);  /* 0x4e31f9: mov dword ptr [ebp - 0x52], ecx */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4e31fc: movsx edx, word ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x41u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4e3200: imul edx, edx, 0x41 */
    eax = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e3203: mov eax, dword ptr [ebp - 0xfc] */
    ecx = (uint32_t)(eax + edx + 0xac1u);  /* 0x4e3209: lea ecx, [eax + edx + 0xac1] */
    edx = RD32((uint32_t)(ecx));  /* 0x4e3210: mov edx, dword ptr [ecx] */
    WR32((uint32_t)(ebp + 0xffffff92u), edx);  /* 0x4e3212: mov dword ptr [ebp - 0x6e], edx */
    eax = RD32((uint32_t)(ecx + 0x4u));  /* 0x4e3215: mov eax, dword ptr [ecx + 4] */
    WR32((uint32_t)(ebp + 0xffffff96u), eax);  /* 0x4e3218: mov dword ptr [ebp - 0x6a], eax */
    edx = RD32((uint32_t)(ecx + 0x8u));  /* 0x4e321b: mov edx, dword ptr [ecx + 8] */
    WR32((uint32_t)(ebp + 0xffffff9au), edx);  /* 0x4e321e: mov dword ptr [ebp - 0x66], edx */
    eax = RD32((uint32_t)(ecx + 0xcu));  /* 0x4e3221: mov eax, dword ptr [ecx + 0xc] */
    WR32((uint32_t)(ebp + 0xffffff9eu), eax);  /* 0x4e3224: mov dword ptr [ebp - 0x62], eax */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4e3227: movsx ecx, word ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x41u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4e322b: imul ecx, ecx, 0x41 */
    edx = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e322e: mov edx, dword ptr [ebp - 0xfc] */
    eax = (uint32_t)(edx + ecx + 0xad1u);  /* 0x4e3234: lea eax, [edx + ecx + 0xad1] */
    edi = eax;  /* 0x4e323b: mov edi, eax */
    edx = (uint32_t)(ebp + 0xffffffcau);  /* 0x4e323d: lea edx, [ebp - 0x36] */
    { uint32_t a_ = ecx, b_ = 0xffffffffu, r_; r_ = a_ | b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x4e3240: or ecx, 0xffffffff */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4e3243: xor eax, eax */
    /* 0x4e3245: repne scasb al, byte ptr es:[edi] */
    while (ecx != 0u) {
    { uint32_t a_ = eax & 0xffu, b_ = RD8(edi), r_;
    FL41_SUB(a_, b_, 0u, r_, 8); }
    edi += 1u;
    ecx -= 1u;
    if (zf) break;
    }
    { uint32_t a_ = ecx; ecx = (~a_) & 0xffffffffu; }  /* 0x4e3247: not ecx */
    { uint32_t a_ = edi, b_ = ecx, r_; FL41_SUB(a_, b_, 0u, r_, 32); edi = r_; }  /* 0x4e3249: sub edi, ecx */
    esi = edi;  /* 0x4e324b: mov esi, edi */
    eax = ecx;  /* 0x4e324d: mov eax, ecx */
    edi = edx;  /* 0x4e324f: mov edi, edx */
    { uint32_t a_ = ecx, n_ = 0x2u, r_; if (n_ != 0u) { FL41_SHR(r_, a_, n_, 32); ecx = r_; } }  /* 0x4e3251: shr ecx, 2 */
    /* 0x4e3254: rep movsd dword ptr es:[edi], dword ptr [esi] */
    while (ecx != 0u) {
    WR32(edi, RD32(esi));
    esi += 4u; edi += 4u;
    ecx -= 1u;
    }
    ecx = eax;  /* 0x4e3256: mov ecx, eax */
    { uint32_t a_ = ecx, b_ = 0x3u, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x4e3258: and ecx, 3 */
    /* 0x4e325b: rep movsb byte ptr es:[edi], byte ptr [esi] */
    while (ecx != 0u) {
    WR8(edi, RD8(esi));
    esi += 1u; edi += 1u;
    ecx -= 1u;
    }
    ecx = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e325d: mov ecx, dword ptr [ebp - 0xfc] */
    edx = RD32((uint32_t)(ecx + 0x6ceu));  /* 0x4e3263: mov edx, dword ptr [ecx + 0x6ce] */
    esp -= 4u; WR32(esp, edx);  /* 0x4e3269: push edx */
    eax = (uint32_t)(ebp + 0xffffff0cu);  /* 0x4e326a: lea eax, [ebp - 0xf4] */
    esp -= 4u; WR32(esp, eax);  /* 0x4e3270: push eax */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4e3271: movsx ecx, word ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x18fu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4e3275: imul ecx, ecx, 0x18f */
    edx = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e327b: mov edx, dword ptr [ebp - 0xfc] */
    ecx = (uint32_t)(edx + ecx + 0x1ca2u);  /* 0x4e3281: lea ecx, [edx + ecx + 0x1ca2] */
    esp -= 4u; WR32(esp, 0x4e328du); FL41_CALL(0x4e204au); esp += 8u; esp += 4u;  /* 0x4e3288: call 0x4e204a */
    goto L_4e3181;  /* 0x4e328d: jmp 0x4e3181 */
L_4e3292:
    esi = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e3292: mov esi, dword ptr [ebp - 0xfc] */
    { uint32_t a_ = esi, b_ = 0x9c2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esi = r_; }  /* 0x4e3298: add esi, 0x9c2 */
    ecx = 0x3bu;  /* 0x4e329e: mov ecx, 0x3b */
    edi = (uint32_t)(ebp + 0xffffff0cu);  /* 0x4e32a3: lea edi, [ebp - 0xf4] */
    /* 0x4e32a9: rep movsd dword ptr es:[edi], dword ptr [esi] */
    while (ecx != 0u) {
    WR32(edi, RD32(esi));
    esi += 4u; edi += 4u;
    ecx -= 1u;
    }
    WR16(edi, RD16(esi)); esi += 2u; edi += 2u;  /* 0x4e32ab: movsw word ptr es:[edi], word ptr [esi] */
    WR8(edi, RD8(esi)); esi += 1u; edi += 1u;  /* 0x4e32ad: movsb byte ptr es:[edi], byte ptr [esi] */
    WR32((uint32_t)(ebp + 0xffffffb6u), 0x1u);  /* 0x4e32ae: mov dword ptr [ebp - 0x4a], 1 */
    WR32((uint32_t)(ebp + 0xffffffb2u), 0x0u);  /* 0x4e32b5: mov dword ptr [ebp - 0x4e], 0 */
    eax = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e32bc: mov eax, dword ptr [ebp - 0xfc] */
    { uint32_t a_ = eax, b_ = 0xf74u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4e32c2: add eax, 0xf74 */
    ecx = RD32((uint32_t)(eax));  /* 0x4e32c7: mov ecx, dword ptr [eax] */
    WR32((uint32_t)(ebp + 0xffffff52u), ecx);  /* 0x4e32c9: mov dword ptr [ebp - 0xae], ecx */
    edx = RD32((uint32_t)(eax + 0x4u));  /* 0x4e32cf: mov edx, dword ptr [eax + 4] */
    WR32((uint32_t)(ebp + 0xffffff56u), edx);  /* 0x4e32d2: mov dword ptr [ebp - 0xaa], edx */
    ecx = RD32((uint32_t)(eax + 0x8u));  /* 0x4e32d8: mov ecx, dword ptr [eax + 8] */
    WR32((uint32_t)(ebp + 0xffffff5au), ecx);  /* 0x4e32db: mov dword ptr [ebp - 0xa6], ecx */
    edx = RD32((uint32_t)(eax + 0xcu));  /* 0x4e32e1: mov edx, dword ptr [eax + 0xc] */
    WR32((uint32_t)(ebp + 0xffffff5eu), edx);  /* 0x4e32e4: mov dword ptr [ebp - 0xa2], edx */
    eax = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e32ea: mov eax, dword ptr [ebp - 0xfc] */
    { uint32_t a_ = eax, b_ = 0xf84u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4e32f0: add eax, 0xf84 */
    ecx = RD32((uint32_t)(eax));  /* 0x4e32f5: mov ecx, dword ptr [eax] */
    WR32((uint32_t)(ebp + 0xffffff62u), ecx);  /* 0x4e32f7: mov dword ptr [ebp - 0x9e], ecx */
    edx = RD32((uint32_t)(eax + 0x4u));  /* 0x4e32fd: mov edx, dword ptr [eax + 4] */
    WR32((uint32_t)(ebp + 0xffffff66u), edx);  /* 0x4e3300: mov dword ptr [ebp - 0x9a], edx */
    ecx = RD32((uint32_t)(eax + 0x8u));  /* 0x4e3306: mov ecx, dword ptr [eax + 8] */
    WR32((uint32_t)(ebp + 0xffffff6au), ecx);  /* 0x4e3309: mov dword ptr [ebp - 0x96], ecx */
    edx = RD32((uint32_t)(eax + 0xcu));  /* 0x4e330f: mov edx, dword ptr [eax + 0xc] */
    WR32((uint32_t)(ebp + 0xffffff6eu), edx);  /* 0x4e3312: mov dword ptr [ebp - 0x92], edx */
    eax = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e3318: mov eax, dword ptr [ebp - 0xfc] */
    { uint32_t a_ = eax, b_ = 0xf94u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4e331e: add eax, 0xf94 */
    ecx = RD32((uint32_t)(eax));  /* 0x4e3323: mov ecx, dword ptr [eax] */
    WR32((uint32_t)(ebp + 0xffffffa2u), ecx);  /* 0x4e3325: mov dword ptr [ebp - 0x5e], ecx */
    edx = RD32((uint32_t)(eax + 0x4u));  /* 0x4e3328: mov edx, dword ptr [eax + 4] */
    WR32((uint32_t)(ebp + 0xffffffa6u), edx);  /* 0x4e332b: mov dword ptr [ebp - 0x5a], edx */
    ecx = RD32((uint32_t)(eax + 0x8u));  /* 0x4e332e: mov ecx, dword ptr [eax + 8] */
    WR32((uint32_t)(ebp + 0xffffffaau), ecx);  /* 0x4e3331: mov dword ptr [ebp - 0x56], ecx */
    edx = RD32((uint32_t)(eax + 0xcu));  /* 0x4e3334: mov edx, dword ptr [eax + 0xc] */
    WR32((uint32_t)(ebp + 0xffffffaeu), edx);  /* 0x4e3337: mov dword ptr [ebp - 0x52], edx */
    eax = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e333a: mov eax, dword ptr [ebp - 0xfc] */
    { uint32_t a_ = eax, b_ = 0xf94u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4e3340: add eax, 0xf94 */
    ecx = RD32((uint32_t)(eax));  /* 0x4e3345: mov ecx, dword ptr [eax] */
    WR32((uint32_t)(ebp + 0xffffff92u), ecx);  /* 0x4e3347: mov dword ptr [ebp - 0x6e], ecx */
    edx = RD32((uint32_t)(eax + 0x4u));  /* 0x4e334a: mov edx, dword ptr [eax + 4] */
    WR32((uint32_t)(ebp + 0xffffff96u), edx);  /* 0x4e334d: mov dword ptr [ebp - 0x6a], edx */
    ecx = RD32((uint32_t)(eax + 0x8u));  /* 0x4e3350: mov ecx, dword ptr [eax + 8] */
    WR32((uint32_t)(ebp + 0xffffff9au), ecx);  /* 0x4e3353: mov dword ptr [ebp - 0x66], ecx */
    edx = RD32((uint32_t)(eax + 0xcu));  /* 0x4e3356: mov edx, dword ptr [eax + 0xc] */
    WR32((uint32_t)(ebp + 0xffffff9eu), edx);  /* 0x4e3359: mov dword ptr [ebp - 0x62], edx */
    eax = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e335c: mov eax, dword ptr [ebp - 0xfc] */
    ecx = RD32((uint32_t)(eax + 0x6ceu));  /* 0x4e3362: mov ecx, dword ptr [eax + 0x6ce] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4e3368: push ecx */
    edx = (uint32_t)(ebp + 0xffffff0cu);  /* 0x4e3369: lea edx, [ebp - 0xf4] */
    esp -= 4u; WR32(esp, edx);  /* 0x4e336f: push edx */
    ecx = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e3370: mov ecx, dword ptr [ebp - 0xfc] */
    { uint32_t a_ = ecx, b_ = 0x3403u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4e3376: add ecx, 0x3403 */
    esp -= 4u; WR32(esp, 0x4e3381u); FL41_CALL(0x4e204au); esp += 8u; esp += 4u;  /* 0x4e337c: call 0x4e204a */
    esi = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e3381: mov esi, dword ptr [ebp - 0xfc] */
    { uint32_t a_ = esi, b_ = 0x9c2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esi = r_; }  /* 0x4e3387: add esi, 0x9c2 */
    ecx = 0x3bu;  /* 0x4e338d: mov ecx, 0x3b */
    edi = (uint32_t)(ebp + 0xffffff0cu);  /* 0x4e3392: lea edi, [ebp - 0xf4] */
    /* 0x4e3398: rep movsd dword ptr es:[edi], dword ptr [esi] */
    while (ecx != 0u) {
    WR32(edi, RD32(esi));
    esi += 4u; edi += 4u;
    ecx -= 1u;
    }
    WR16(edi, RD16(esi)); esi += 2u; edi += 2u;  /* 0x4e339a: movsw word ptr es:[edi], word ptr [esi] */
    WR8(edi, RD8(esi)); esi += 1u; edi += 1u;  /* 0x4e339c: movsb byte ptr es:[edi], byte ptr [esi] */
    WR32((uint32_t)(ebp + 0xffffffb6u), 0x1u);  /* 0x4e339d: mov dword ptr [ebp - 0x4a], 1 */
    WR32((uint32_t)(ebp + 0xffffffb2u), 0x0u);  /* 0x4e33a4: mov dword ptr [ebp - 0x4e], 0 */
    eax = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e33ab: mov eax, dword ptr [ebp - 0xfc] */
    { uint32_t a_ = eax, b_ = 0x111du, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4e33b1: add eax, 0x111d */
    WR32((uint32_t)(ebp + 0xffffff08u), eax);  /* 0x4e33b6: mov dword ptr [ebp - 0xf8], eax */
    WR16((uint32_t)(ebp + 0xfffffffcu), 0x10u);  /* 0x4e33bc: mov word ptr [ebp - 4], 0x10 */
    goto L_4e33d0;  /* 0x4e33c2: jmp 0x4e33d0 */
L_4e33c4:
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffffcu))) & 0xffffu);  /* 0x4e33c4: mov cx, word ptr [ebp - 4] */
    { uint32_t a_ = (ecx & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); ecx = (ecx & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4e33c8: add cx, 1 */
    WR16((uint32_t)(ebp + 0xfffffffcu), (ecx & 0xffffu));  /* 0x4e33cc: mov word ptr [ebp - 4], cx */
L_4e33d0:
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4e33d0: movsx edx, word ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x19u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e33d4: cmp edx, 0x19 */
    if ((!zf && sf == of)) goto L_4e34ef;  /* 0x4e33d7: jg 0x4e34ef */
    eax = RD32((uint32_t)(ebp + 0xffffff08u));  /* 0x4e33dd: mov eax, dword ptr [ebp - 0xf8] */
    ecx = RD32((uint32_t)(eax));  /* 0x4e33e3: mov ecx, dword ptr [eax] */
    WR32((uint32_t)(ebp + 0xffffff52u), ecx);  /* 0x4e33e5: mov dword ptr [ebp - 0xae], ecx */
    edx = RD32((uint32_t)(eax + 0x4u));  /* 0x4e33eb: mov edx, dword ptr [eax + 4] */
    WR32((uint32_t)(ebp + 0xffffff56u), edx);  /* 0x4e33ee: mov dword ptr [ebp - 0xaa], edx */
    ecx = RD32((uint32_t)(eax + 0x8u));  /* 0x4e33f4: mov ecx, dword ptr [eax + 8] */
    WR32((uint32_t)(ebp + 0xffffff5au), ecx);  /* 0x4e33f7: mov dword ptr [ebp - 0xa6], ecx */
    edx = RD32((uint32_t)(eax + 0xcu));  /* 0x4e33fd: mov edx, dword ptr [eax + 0xc] */
    WR32((uint32_t)(ebp + 0xffffff5eu), edx);  /* 0x4e3400: mov dword ptr [ebp - 0xa2], edx */
    eax = RD32((uint32_t)(ebp + 0xffffff08u));  /* 0x4e3406: mov eax, dword ptr [ebp - 0xf8] */
    { uint32_t a_ = eax, b_ = 0x10u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4e340c: add eax, 0x10 */
    WR32((uint32_t)(ebp + 0xffffff08u), eax);  /* 0x4e340f: mov dword ptr [ebp - 0xf8], eax */
    ecx = RD32((uint32_t)(ebp + 0xffffff08u));  /* 0x4e3415: mov ecx, dword ptr [ebp - 0xf8] */
    edx = RD32((uint32_t)(ecx));  /* 0x4e341b: mov edx, dword ptr [ecx] */
    WR32((uint32_t)(ebp + 0xffffff62u), edx);  /* 0x4e341d: mov dword ptr [ebp - 0x9e], edx */
    eax = RD32((uint32_t)(ecx + 0x4u));  /* 0x4e3423: mov eax, dword ptr [ecx + 4] */
    WR32((uint32_t)(ebp + 0xffffff66u), eax);  /* 0x4e3426: mov dword ptr [ebp - 0x9a], eax */
    edx = RD32((uint32_t)(ecx + 0x8u));  /* 0x4e342c: mov edx, dword ptr [ecx + 8] */
    WR32((uint32_t)(ebp + 0xffffff6au), edx);  /* 0x4e342f: mov dword ptr [ebp - 0x96], edx */
    eax = RD32((uint32_t)(ecx + 0xcu));  /* 0x4e3435: mov eax, dword ptr [ecx + 0xc] */
    WR32((uint32_t)(ebp + 0xffffff6eu), eax);  /* 0x4e3438: mov dword ptr [ebp - 0x92], eax */
    ecx = RD32((uint32_t)(ebp + 0xffffff08u));  /* 0x4e343e: mov ecx, dword ptr [ebp - 0xf8] */
    { uint32_t a_ = ecx, b_ = 0x10u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4e3444: add ecx, 0x10 */
    WR32((uint32_t)(ebp + 0xffffff08u), ecx);  /* 0x4e3447: mov dword ptr [ebp - 0xf8], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffff08u));  /* 0x4e344d: mov edx, dword ptr [ebp - 0xf8] */
    eax = RD32((uint32_t)(edx));  /* 0x4e3453: mov eax, dword ptr [edx] */
    WR32((uint32_t)(ebp + 0xffffffa2u), eax);  /* 0x4e3455: mov dword ptr [ebp - 0x5e], eax */
    ecx = RD32((uint32_t)(edx + 0x4u));  /* 0x4e3458: mov ecx, dword ptr [edx + 4] */
    WR32((uint32_t)(ebp + 0xffffffa6u), ecx);  /* 0x4e345b: mov dword ptr [ebp - 0x5a], ecx */
    eax = RD32((uint32_t)(edx + 0x8u));  /* 0x4e345e: mov eax, dword ptr [edx + 8] */
    WR32((uint32_t)(ebp + 0xffffffaau), eax);  /* 0x4e3461: mov dword ptr [ebp - 0x56], eax */
    ecx = RD32((uint32_t)(edx + 0xcu));  /* 0x4e3464: mov ecx, dword ptr [edx + 0xc] */
    WR32((uint32_t)(ebp + 0xffffffaeu), ecx);  /* 0x4e3467: mov dword ptr [ebp - 0x52], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e346a: mov edx, dword ptr [ebp - 0xfc] */
    { uint32_t a_ = edx, b_ = 0xf94u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4e3470: add edx, 0xf94 */
    eax = RD32((uint32_t)(edx));  /* 0x4e3476: mov eax, dword ptr [edx] */
    WR32((uint32_t)(ebp + 0xffffff92u), eax);  /* 0x4e3478: mov dword ptr [ebp - 0x6e], eax */
    ecx = RD32((uint32_t)(edx + 0x4u));  /* 0x4e347b: mov ecx, dword ptr [edx + 4] */
    WR32((uint32_t)(ebp + 0xffffff96u), ecx);  /* 0x4e347e: mov dword ptr [ebp - 0x6a], ecx */
    eax = RD32((uint32_t)(edx + 0x8u));  /* 0x4e3481: mov eax, dword ptr [edx + 8] */
    WR32((uint32_t)(ebp + 0xffffff9au), eax);  /* 0x4e3484: mov dword ptr [ebp - 0x66], eax */
    ecx = RD32((uint32_t)(edx + 0xcu));  /* 0x4e3487: mov ecx, dword ptr [edx + 0xc] */
    WR32((uint32_t)(ebp + 0xffffff9eu), ecx);  /* 0x4e348a: mov dword ptr [ebp - 0x62], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e348d: mov edx, dword ptr [ebp - 0xfc] */
    eax = RD32((uint32_t)(edx + 0x6ceu));  /* 0x4e3493: mov eax, dword ptr [edx + 0x6ce] */
    esp -= 4u; WR32(esp, eax);  /* 0x4e3499: push eax */
    ecx = (uint32_t)(ebp + 0xffffff0cu);  /* 0x4e349a: lea ecx, [ebp - 0xf4] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4e34a0: push ecx */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4e34a1: movsx edx, word ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x18fu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4e34a5: imul edx, edx, 0x18f */
    eax = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e34ab: mov eax, dword ptr [ebp - 0xfc] */
    ecx = (uint32_t)(eax + edx + 0x1ca2u);  /* 0x4e34b1: lea ecx, [eax + edx + 0x1ca2] */
    esp -= 4u; WR32(esp, 0x4e34bdu); FL41_CALL(0x4e204au); esp += 8u; esp += 4u;  /* 0x4e34b8: call 0x4e204a */
    esp -= 4u; WR32(esp, 0x4u);  /* 0x4e34bd: push 4 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4e34bf: movsx ecx, word ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x18fu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4e34c3: imul ecx, ecx, 0x18f */
    edx = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e34c9: mov edx, dword ptr [ebp - 0xfc] */
    ecx = (uint32_t)(edx + ecx + 0x1ca2u);  /* 0x4e34cf: lea ecx, [edx + ecx + 0x1ca2] */
    esp -= 4u; WR32(esp, 0x4e34dbu); FL41_CALL(0x4e2940u); esp += 4u; esp += 4u;  /* 0x4e34d6: call 0x4e2940 */
    eax = RD32((uint32_t)(ebp + 0xffffff08u));  /* 0x4e34db: mov eax, dword ptr [ebp - 0xf8] */
    { uint32_t a_ = eax, b_ = 0x10u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4e34e1: add eax, 0x10 */
    WR32((uint32_t)(ebp + 0xffffff08u), eax);  /* 0x4e34e4: mov dword ptr [ebp - 0xf8], eax */
    goto L_4e33c4;  /* 0x4e34ea: jmp 0x4e33c4 */
L_4e34ef:
    ecx = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e34ef: mov ecx, dword ptr [ebp - 0xfc] */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ecx + 0x140au))) & 0xffffu);  /* 0x4e34f5: mov dx, word ptr [ecx + 0x140a] */
    esp -= 4u; WR32(esp, edx);  /* 0x4e34fc: push edx */
    ecx = 0x5cf659u;  /* 0x4e34fd: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4e3507u); FL41_CALL(0x4c924du); esp += 4u; esp += 4u;  /* 0x4e3502: call 0x4c924d */
    eax = RD32((uint32_t)(ebp + 0xffffff04u));  /* 0x4e3507: mov eax, dword ptr [ebp - 0xfc] */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(eax + 0x140cu))) & 0xffffu);  /* 0x4e350d: mov cx, word ptr [eax + 0x140c] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4e3514: push ecx */
    ecx = 0x5cf659u;  /* 0x4e3515: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4e351fu); FL41_CALL(0x4c924du); esp += 4u; esp += 4u;  /* 0x4e351a: call 0x4c924d */
L_4e351f:
    edi = RD32(esp); esp += 4u;  /* 0x4e351f: pop edi */
    esi = RD32(esp); esp += 4u;  /* 0x4e3520: pop esi */
    esp = ebp;  /* 0x4e3521: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4e3523: pop ebp */
    esp += 4u; goto done;  /* 0x4e3524: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4e4a3a (394 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4e4a3a_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4e4a3a: push ebp */
    ebp = esp;  /* 0x4e4a3b: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x18u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4e4a3d: sub esp, 0x18 */
    WR32((uint32_t)(ebp + 0xffffffecu), ecx);  /* 0x4e4a40: mov dword ptr [ebp - 0x14], ecx */
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0x10u))) & 0xffffu);  /* 0x4e4a43: mov ax, word ptr [ebp + 0x10] */
    WR16((uint32_t)(ebp + 0xfffffff0u), (eax & 0xffffu));  /* 0x4e4a47: mov word ptr [ebp - 0x10], ax */
    ecx = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x4e4a4b: mov ecx, dword ptr [ebp - 0x14] */
    WR16((uint32_t)(ecx + 0x53bdu), 0x0u);  /* 0x4e4a4e: mov word ptr [ecx + 0x53bd], 0 */
    edx = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x4e4a57: mov edx, dword ptr [ebp - 0x14] */
    WR16((uint32_t)(edx + 0x65d6u), 0x0u);  /* 0x4e4a5a: mov word ptr [edx + 0x65d6], 0 */
    eax = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x4e4a63: mov eax, dword ptr [ebp - 0x14] */
    ecx = RD32((uint32_t)(eax + 0x4530u));  /* 0x4e4a66: mov ecx, dword ptr [eax + 0x4530] */
    WR32((uint32_t)(ebp + 0xffffffe8u), ecx);  /* 0x4e4a6c: mov dword ptr [ebp - 0x18], ecx */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xffffffe8u)), b_ = 0x9u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e4a6f: cmp dword ptr [ebp - 0x18], 9 */
    if (zf) goto L_4e4a8a;  /* 0x4e4a73: je 0x4e4a8a */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xffffffe8u)), b_ = 0xdu, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e4a75: cmp dword ptr [ebp - 0x18], 0xd */
    if (zf) goto L_4e4b0e;  /* 0x4e4a79: je 0x4e4b0e */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xffffffe8u)), b_ = 0xeu, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e4a7f: cmp dword ptr [ebp - 0x18], 0xe */
    if (zf) goto L_4e4a9a;  /* 0x4e4a83: je 0x4e4a9a */
    goto L_4e4b19;  /* 0x4e4a85: jmp 0x4e4b19 */
L_4e4a8a:
    edx = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x4e4a8a: mov edx, dword ptr [ebp - 0x14] */
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(edx + 0x1473u))) & 0xffffu);  /* 0x4e4a8d: mov ax, word ptr [edx + 0x1473] */
    WR16((uint32_t)(ebp + 0xfffffffcu), (eax & 0xffffu));  /* 0x4e4a94: mov word ptr [ebp - 4], ax */
    goto L_4e4b19;  /* 0x4e4a98: jmp 0x4e4b19 */
L_4e4a9a:
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(0x5a1e5eu))) & 0xffffu);  /* 0x4e4a9a: mov cx, word ptr [0x5a1e5e] */
    WR16((uint32_t)(ebp + 0xfffffffcu), (ecx & 0xffffu));  /* 0x4e4aa1: mov word ptr [ebp - 4], cx */
    { uint32_t a_ = RD32((uint32_t)(0x5a1e58u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e4aa5: cmp dword ptr [0x5a1e58], 0 */
    if (zf) goto L_4e4b0c;  /* 0x4e4aac: je 0x4e4b0c */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffffcu))) & 0xffffu);  /* 0x4e4aae: mov dx, word ptr [ebp - 4] */
    WR16((uint32_t)(ebp + 0xfffffff4u), (edx & 0xffffu));  /* 0x4e4ab2: mov word ptr [ebp - 0xc], dx */
    WR16((uint32_t)(ebp + 0xfffffff8u), 0x0u);  /* 0x4e4ab6: mov word ptr [ebp - 8], 0 */
    goto L_4e4aca;  /* 0x4e4abc: jmp 0x4e4aca */
L_4e4abe:
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffff8u))) & 0xffffu);  /* 0x4e4abe: mov ax, word ptr [ebp - 8] */
    { uint32_t a_ = (eax & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); eax = (eax & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4e4ac2: add ax, 1 */
    WR16((uint32_t)(ebp + 0xfffffff8u), (eax & 0xffffu));  /* 0x4e4ac6: mov word ptr [ebp - 8], ax */
L_4e4aca:
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4e4aca: movsx ecx, word ptr [ebp - 8] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff4u)))) & 0xffffffffu;  /* 0x4e4ace: movsx edx, word ptr [ebp - 0xc] */
    { uint32_t a_ = ecx, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e4ad2: cmp ecx, edx */
    if ((sf == of)) goto L_4e4b0c;  /* 0x4e4ad4: jge 0x4e4b0c */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4e4ad6: movsx eax, word ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x4au); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4e4ada: imul eax, eax, 0x4a */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x5a26aau)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e4add: cmp dword ptr [eax + 0x5a26aa], 0 */
    if (!zf) goto L_4e4b0a;  /* 0x4e4ae4: jne 0x4e4b0a */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffffcu))) & 0xffffu);  /* 0x4e4ae6: mov cx, word ptr [ebp - 4] */
    { uint32_t a_ = (ecx & 0xffffu), b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 16); ecx = (ecx & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4e4aea: sub cx, 1 */
    WR16((uint32_t)(ebp + 0xfffffffcu), (ecx & 0xffffu));  /* 0x4e4aee: mov word ptr [ebp - 4], cx */
    edx = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x4e4af2: mov edx, dword ptr [ebp - 0x14] */
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(edx + 0x65d6u))) & 0xffffu);  /* 0x4e4af5: mov ax, word ptr [edx + 0x65d6] */
    { uint32_t a_ = (eax & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); eax = (eax & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4e4afc: add ax, 1 */
    ecx = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x4e4b00: mov ecx, dword ptr [ebp - 0x14] */
    WR16((uint32_t)(ecx + 0x65d6u), (eax & 0xffffu));  /* 0x4e4b03: mov word ptr [ecx + 0x65d6], ax */
L_4e4b0a:
    goto L_4e4abe;  /* 0x4e4b0a: jmp 0x4e4abe */
L_4e4b0c:
    goto L_4e4b19;  /* 0x4e4b0c: jmp 0x4e4b19 */
L_4e4b0e:
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(0x5a1e60u))) & 0xffffu);  /* 0x4e4b0e: mov dx, word ptr [0x5a1e60] */
    WR16((uint32_t)(ebp + 0xfffffffcu), (edx & 0xffffu));  /* 0x4e4b15: mov word ptr [ebp - 4], dx */
L_4e4b19:
    WR16((uint32_t)(ebp + 0xfffffff8u), 0x0u);  /* 0x4e4b19: mov word ptr [ebp - 8], 0 */
    goto L_4e4b2d;  /* 0x4e4b1f: jmp 0x4e4b2d */
L_4e4b21:
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffff8u))) & 0xffffu);  /* 0x4e4b21: mov ax, word ptr [ebp - 8] */
    { uint32_t a_ = (eax & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); eax = (eax & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4e4b25: add ax, 1 */
    WR16((uint32_t)(ebp + 0xfffffff8u), (eax & 0xffffu));  /* 0x4e4b29: mov word ptr [ebp - 8], ax */
L_4e4b2d:
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff0u)))) & 0xffffffffu;  /* 0x4e4b2d: movsx ecx, word ptr [ebp - 0x10] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x18u)))) & 0xffffffffu;  /* 0x4e4b31: movsx edx, word ptr [ebp + 0x18] */
    { uint32_t a_ = ecx, b_ = edx, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4e4b35: add ecx, edx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x14u)))) & 0xffffffffu;  /* 0x4e4b37: movsx eax, word ptr [ebp + 0x14] */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e4b3b: cmp ecx, eax */
    if ((sf == of)) goto L_4e4bb0;  /* 0x4e4b3d: jge 0x4e4bb0 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4e4b3f: movsx ecx, word ptr [ebp - 8] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4e4b43: movsx edx, word ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e4b47: cmp ecx, edx */
    if ((sf == of)) goto L_4e4bb0;  /* 0x4e4b49: jge 0x4e4bb0 */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff0u)))) & 0xffffffffu;  /* 0x4e4b4b: movsx eax, word ptr [ebp - 0x10] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4e4b4f: movsx ecx, word ptr [ebp - 8] */
    { uint32_t a_ = ecx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); ecx = r_; } }  /* 0x4e4b53: shl ecx, 4 */
    edx = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x4e4b56: mov edx, dword ptr [ebp - 0x14] */
    WR32((uint32_t)(edx + ecx + 0x4d81u), eax);  /* 0x4e4b59: mov dword ptr [edx + ecx + 0x4d81], eax */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4e4b60: movsx eax, word ptr [ebp + 8] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4e4b64: movsx ecx, word ptr [ebp - 8] */
    { uint32_t a_ = ecx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); ecx = r_; } }  /* 0x4e4b68: shl ecx, 4 */
    edx = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x4e4b6b: mov edx, dword ptr [ebp - 0x14] */
    WR32((uint32_t)(edx + ecx + 0x4d7du), eax);  /* 0x4e4b6e: mov dword ptr [edx + ecx + 0x4d7d], eax */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xcu)))) & 0xffffffffu;  /* 0x4e4b75: movsx eax, word ptr [ebp + 0xc] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4e4b79: movsx ecx, word ptr [ebp - 8] */
    { uint32_t a_ = ecx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); ecx = r_; } }  /* 0x4e4b7d: shl ecx, 4 */
    edx = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x4e4b80: mov edx, dword ptr [ebp - 0x14] */
    WR32((uint32_t)(edx + ecx + 0x4d85u), eax);  /* 0x4e4b83: mov dword ptr [edx + ecx + 0x4d85], eax */
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffff0u))) & 0xffffu);  /* 0x4e4b8a: mov ax, word ptr [ebp - 0x10] */
    { uint32_t a_ = (eax & 0xffffu), b_ = RD16((uint32_t)(ebp + 0x18u)), r_; FL41_ADD(a_, b_, 0u, r_, 16); eax = (eax & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4e4b8e: add ax, word ptr [ebp + 0x18] */
    WR16((uint32_t)(ebp + 0xfffffff0u), (eax & 0xffffu));  /* 0x4e4b92: mov word ptr [ebp - 0x10], ax */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff0u)))) & 0xffffffffu;  /* 0x4e4b96: movsx ecx, word ptr [ebp - 0x10] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4e4b9a: movsx edx, word ptr [ebp - 8] */
    { uint32_t a_ = edx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); edx = r_; } }  /* 0x4e4b9e: shl edx, 4 */
    eax = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x4e4ba1: mov eax, dword ptr [ebp - 0x14] */
    WR32((uint32_t)(eax + edx + 0x4d89u), ecx);  /* 0x4e4ba4: mov dword ptr [eax + edx + 0x4d89], ecx */
    goto L_4e4b21;  /* 0x4e4bab: jmp 0x4e4b21 */
L_4e4bb0:
    ecx = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x4e4bb0: mov ecx, dword ptr [ebp - 0x14] */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffff8u))) & 0xffffu);  /* 0x4e4bb3: mov dx, word ptr [ebp - 8] */
    WR16((uint32_t)(ecx + 0x53bdu), (edx & 0xffffu));  /* 0x4e4bb7: mov word ptr [ecx + 0x53bd], dx */
    esp = ebp;  /* 0x4e4bbe: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4e4bc0: pop ebp */
    esp += 24u; goto done;  /* 0x4e4bc1: ret 0x14 */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4e8622 (882 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4e8622_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4e8622: push ebp */
    ebp = esp;  /* 0x4e8623: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4e8625: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4e8626: mov dword ptr [ebp - 4], ecx */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8629: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4e8631u); FL41_CALL(0x4ee572u); esp += 4u;  /* 0x4e862c: call 0x4ee572 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4e8631: test eax, eax */
    if (zf) goto L_4e8686;  /* 0x4e8633: je 0x4e8686 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8635: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4e863du); FL41_CALL(0x4ee5f2u); esp += 4u;  /* 0x4e8638: call 0x4ee5f2 */
    esp -= 4u; WR32(esp, eax);  /* 0x4e863d: push eax */
    esp -= 4u; WR32(esp, 0x55c5f0u);  /* 0x4e863e: push 0x55c5f0 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4e8643: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4e864du); FL41_CALL(0x50ca3eu); esp += 4u;  /* 0x4e8648: call 0x50ca3e */
    { uint32_t a_ = esp, b_ = 0xcu, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4e864d: add esp, 0xc */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4e8650: push 0x63888b */
    ecx = 0x583979u;  /* 0x4e8655: mov ecx, 0x583979 */
    esp -= 4u; WR32(esp, 0x4e865fu); FL41_CALL(0x4264e8u); esp += 4u; esp += 4u;  /* 0x4e865a: call 0x4264e8 */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x63a4cdu)))) & 0xffffffffu;  /* 0x4e865f: movsx eax, word ptr [0x63a4cd] */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4e8666: test eax, eax */
    if (zf) goto L_4e8677;  /* 0x4e8668: je 0x4e8677 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4e866a: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4e8674u); FL41_CALL(0x44a2b7u); esp += 4u;  /* 0x4e866f: call 0x44a2b7 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4e8674: add esp, 4 */
L_4e8677:
    ecx = 0x5cf659u;  /* 0x4e8677: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4e8681u); FL41_CALL(0x4c97b4u); esp += 4u;  /* 0x4e867c: call 0x4c97b4 */
    goto L_4e8990;  /* 0x4e8681: jmp 0x4e8990 */
L_4e8686:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8686: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4e868eu); FL41_CALL(0x4e7ba7u); esp += 4u;  /* 0x4e8689: call 0x4e7ba7 */
    esp -= 4u; WR32(esp, 0x1u);  /* 0x4e868e: push 1 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8690: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x6b20u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4e8693: add ecx, 0x6b20 */
    esp -= 4u; WR32(esp, ecx);  /* 0x4e8699: push ecx */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e869a: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4e86a2u); FL41_CALL(0x4edcb1u); esp += 8u; esp += 4u;  /* 0x4e869d: call 0x4edcb1 */
    esp -= 4u; WR32(esp, 0x1u);  /* 0x4e86a2: push 1 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e86a4: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4e86acu); FL41_CALL(0x4ee6c7u); esp += 4u; esp += 4u;  /* 0x4e86a7: call 0x4ee6c7 */
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4e86ac: push 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e86ae: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4e86b6u); FL41_CALL(0x4ee673u); esp += 4u; esp += 4u;  /* 0x4e86b1: call 0x4ee673 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e86b6: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x822eu), 0x0u);  /* 0x4e86b9: mov dword ptr [edx + 0x822e], 0 */
    goto L_4e86da;  /* 0x4e86c3: jmp 0x4e86da */
L_4e86c5:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e86c5: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x822eu));  /* 0x4e86c8: mov ecx, dword ptr [eax + 0x822e] */
    { uint32_t a_ = ecx, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4e86ce: add ecx, 1 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e86d1: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x822eu), ecx);  /* 0x4e86d4: mov dword ptr [edx + 0x822e], ecx */
L_4e86da:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e86da: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x822eu)), b_ = 0x10u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e86dd: cmp dword ptr [eax + 0x822e], 0x10 */
    if ((sf == of)) goto L_4e884d;  /* 0x4e86e4: jge 0x4e884d */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e86ea: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(ecx + 0x6b87u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e86ed: cmp dword ptr [ecx + 0x6b87], 0 */
    if (zf) goto L_4e87c4;  /* 0x4e86f4: je 0x4e87c4 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e86fa: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x822eu));  /* 0x4e86fd: mov eax, dword ptr [edx + 0x822e] */
    { uint32_t a_ = eax, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); eax = r_; } }  /* 0x4e8703: shl eax, 4 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8706: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + eax + 0x6f10u));  /* 0x4e8709: mov edx, dword ptr [ecx + eax + 0x6f10] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4e8710: add edx, dword ptr [0x583186] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8716: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x822eu));  /* 0x4e8719: mov ecx, dword ptr [eax + 0x822e] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x28u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4e871f: imul ecx, ecx, 0x28 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8722: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + ecx + 0x7fc6u), edx);  /* 0x4e8725: mov dword ptr [eax + ecx + 0x7fc6], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e872c: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x822eu));  /* 0x4e872f: mov edx, dword ptr [ecx + 0x822e] */
    { uint32_t a_ = edx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); edx = r_; } }  /* 0x4e8735: shl edx, 4 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8738: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + edx + 0x6f18u));  /* 0x4e873b: mov ecx, dword ptr [eax + edx + 0x6f18] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4e8742: add ecx, dword ptr [0x583186] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8748: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x822eu));  /* 0x4e874b: mov eax, dword ptr [edx + 0x822e] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x28u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4e8751: imul eax, eax, 0x28 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8754: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + eax + 0x7fceu), ecx);  /* 0x4e8757: mov dword ptr [edx + eax + 0x7fce], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e875e: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x822eu));  /* 0x4e8761: mov ecx, dword ptr [eax + 0x822e] */
    { uint32_t a_ = ecx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); ecx = r_; } }  /* 0x4e8767: shl ecx, 4 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e876a: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + ecx + 0x6f14u));  /* 0x4e876d: mov eax, dword ptr [edx + ecx + 0x6f14] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4e8774: add eax, dword ptr [0x58318a] */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e877a: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x822eu));  /* 0x4e877d: mov edx, dword ptr [ecx + 0x822e] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x28u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4e8783: imul edx, edx, 0x28 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8786: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + edx + 0x7fcau), eax);  /* 0x4e8789: mov dword ptr [ecx + edx + 0x7fca], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8790: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x822eu));  /* 0x4e8793: mov eax, dword ptr [edx + 0x822e] */
    { uint32_t a_ = eax, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); eax = r_; } }  /* 0x4e8799: shl eax, 4 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e879c: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + eax + 0x6f1cu));  /* 0x4e879f: mov edx, dword ptr [ecx + eax + 0x6f1c] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4e87a6: add edx, dword ptr [0x58318a] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e87ac: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x822eu));  /* 0x4e87af: mov ecx, dword ptr [eax + 0x822e] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x28u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4e87b5: imul ecx, ecx, 0x28 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e87b8: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + ecx + 0x7fd2u), edx);  /* 0x4e87bb: mov dword ptr [eax + ecx + 0x7fd2], edx */
    goto L_4e8806;  /* 0x4e87c2: jmp 0x4e8806 */
L_4e87c4:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e87c4: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x822eu));  /* 0x4e87c7: mov edx, dword ptr [ecx + 0x822e] */
    { uint32_t a_ = edx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); edx = r_; } }  /* 0x4e87cd: shl edx, 4 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e87d0: mov eax, dword ptr [ebp - 4] */
    ecx = (uint32_t)(eax + edx + 0x6f10u);  /* 0x4e87d3: lea ecx, [eax + edx + 0x6f10] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e87da: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x822eu));  /* 0x4e87dd: mov eax, dword ptr [edx + 0x822e] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x28u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4e87e3: imul eax, eax, 0x28 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e87e6: mov edx, dword ptr [ebp - 4] */
    eax = (uint32_t)(edx + eax + 0x7fc6u);  /* 0x4e87e9: lea eax, [edx + eax + 0x7fc6] */
    edx = RD32((uint32_t)(ecx));  /* 0x4e87f0: mov edx, dword ptr [ecx] */
    WR32((uint32_t)(eax), edx);  /* 0x4e87f2: mov dword ptr [eax], edx */
    edx = RD32((uint32_t)(ecx + 0x4u));  /* 0x4e87f4: mov edx, dword ptr [ecx + 4] */
    WR32((uint32_t)(eax + 0x4u), edx);  /* 0x4e87f7: mov dword ptr [eax + 4], edx */
    edx = RD32((uint32_t)(ecx + 0x8u));  /* 0x4e87fa: mov edx, dword ptr [ecx + 8] */
    WR32((uint32_t)(eax + 0x8u), edx);  /* 0x4e87fd: mov dword ptr [eax + 8], edx */
    ecx = RD32((uint32_t)(ecx + 0xcu));  /* 0x4e8800: mov ecx, dword ptr [ecx + 0xc] */
    WR32((uint32_t)(eax + 0xcu), ecx);  /* 0x4e8803: mov dword ptr [eax + 0xc], ecx */
L_4e8806:
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8806: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x822eu));  /* 0x4e8809: mov eax, dword ptr [edx + 0x822e] */
    { uint32_t a_ = eax, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); eax = r_; } }  /* 0x4e880f: shl eax, 4 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8812: mov ecx, dword ptr [ebp - 4] */
    edx = (uint32_t)(ecx + eax + 0x6e10u);  /* 0x4e8815: lea edx, [ecx + eax + 0x6e10] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e881c: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x822eu));  /* 0x4e881f: mov ecx, dword ptr [eax + 0x822e] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x28u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4e8825: imul ecx, ecx, 0x28 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8828: mov eax, dword ptr [ebp - 4] */
    ecx = (uint32_t)(eax + ecx + 0x7fb6u);  /* 0x4e882b: lea ecx, [eax + ecx + 0x7fb6] */
    eax = RD32((uint32_t)(edx));  /* 0x4e8832: mov eax, dword ptr [edx] */
    WR32((uint32_t)(ecx), eax);  /* 0x4e8834: mov dword ptr [ecx], eax */
    eax = RD32((uint32_t)(edx + 0x4u));  /* 0x4e8836: mov eax, dword ptr [edx + 4] */
    WR32((uint32_t)(ecx + 0x4u), eax);  /* 0x4e8839: mov dword ptr [ecx + 4], eax */
    eax = RD32((uint32_t)(edx + 0x8u));  /* 0x4e883c: mov eax, dword ptr [edx + 8] */
    WR32((uint32_t)(ecx + 0x8u), eax);  /* 0x4e883f: mov dword ptr [ecx + 8], eax */
    edx = RD32((uint32_t)(edx + 0xcu));  /* 0x4e8842: mov edx, dword ptr [edx + 0xc] */
    WR32((uint32_t)(ecx + 0xcu), edx);  /* 0x4e8845: mov dword ptr [ecx + 0xc], edx */
    goto L_4e86c5;  /* 0x4e8848: jmp 0x4e86c5 */
L_4e884d:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e884d: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x822eu), 0x0u);  /* 0x4e8850: mov dword ptr [eax + 0x822e], 0 */
    goto L_4e8871;  /* 0x4e885a: jmp 0x4e8871 */
L_4e885c:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e885c: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x822eu));  /* 0x4e885f: mov edx, dword ptr [ecx + 0x822e] */
    { uint32_t a_ = edx, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4e8865: add edx, 1 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8868: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x822eu), edx);  /* 0x4e886b: mov dword ptr [eax + 0x822e], edx */
L_4e8871:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8871: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(ecx + 0x822eu)), b_ = 0x6u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e8874: cmp dword ptr [ecx + 0x822e], 6 */
    if ((sf == of)) goto L_4e8990;  /* 0x4e887b: jge 0x4e8990 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8881: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x822eu));  /* 0x4e8884: mov eax, dword ptr [edx + 0x822e] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0xf7u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4e888a: imul eax, eax, 0xf7 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8890: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(ecx + eax + 0x7012u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e8893: cmp dword ptr [ecx + eax + 0x7012], 0 */
    if (zf) goto L_4e898b;  /* 0x4e889b: je 0x4e898b */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e88a1: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x822eu));  /* 0x4e88a4: mov eax, dword ptr [edx + 0x822e] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0xf7u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4e88aa: imul eax, eax, 0xf7 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e88b0: mov ecx, dword ptr [ebp - 4] */
    edx = (uint32_t)(ecx + eax + 0x701au);  /* 0x4e88b3: lea edx, [ecx + eax + 0x701a] */
    esp -= 4u; WR32(esp, edx);  /* 0x4e88ba: push edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e88bb: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x822eu));  /* 0x4e88be: mov ecx, dword ptr [eax + 0x822e] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x18fu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4e88c4: imul ecx, ecx, 0x18f */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e88ca: mov edx, dword ptr [ebp - 4] */
    ecx = (uint32_t)(edx + ecx + 0x7654u);  /* 0x4e88cd: lea ecx, [edx + ecx + 0x7654] */
    esp -= 4u; WR32(esp, 0x4e88d9u); FL41_CALL(0x4e1db3u); esp += 4u; esp += 4u;  /* 0x4e88d4: call 0x4e1db3 */
    esp -= 4u; WR32(esp, 0x1u);  /* 0x4e88d9: push 1 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e88db: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x822eu));  /* 0x4e88de: mov ecx, dword ptr [eax + 0x822e] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x18fu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4e88e4: imul ecx, ecx, 0x18f */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e88ea: mov edx, dword ptr [ebp - 4] */
    ecx = (uint32_t)(edx + ecx + 0x7654u);  /* 0x4e88ed: lea ecx, [edx + ecx + 0x7654] */
    esp -= 4u; WR32(esp, 0x4e88f9u); FL41_CALL(0x4e2990u); esp += 4u; esp += 4u;  /* 0x4e88f4: call 0x4e2990 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e88f9: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x8232u)), b_ = 0xffffffffu, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e88fc: cmp dword ptr [eax + 0x8232], -1 */
    if (!zf) goto L_4e896b;  /* 0x4e8903: jne 0x4e896b */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8905: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x822eu));  /* 0x4e8908: mov edx, dword ptr [ecx + 0x822e] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0xf7u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4e890e: imul edx, edx, 0xf7 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8914: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8917: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + edx + 0x7016u));  /* 0x4e891a: mov edx, dword ptr [ecx + edx + 0x7016] */
    WR32((uint32_t)(eax + 0x8232u), edx);  /* 0x4e8921: mov dword ptr [eax + 0x8232], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8927: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x822eu));  /* 0x4e892a: mov ecx, dword ptr [eax + 0x822e] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0xf7u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4e8930: imul ecx, ecx, 0xf7 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8936: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e8939: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + ecx + 0x7016u));  /* 0x4e893c: mov ecx, dword ptr [eax + ecx + 0x7016] */
    WR32((uint32_t)(edx + 0x8236u), ecx);  /* 0x4e8943: mov dword ptr [edx + 0x8236], ecx */
    esp -= 4u; WR32(esp, 0x1u);  /* 0x4e8949: push 1 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e894b: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x822eu));  /* 0x4e894e: mov eax, dword ptr [edx + 0x822e] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x18fu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4e8954: imul eax, eax, 0x18f */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e895a: mov ecx, dword ptr [ebp - 4] */
    ecx = (uint32_t)(ecx + eax + 0x7654u);  /* 0x4e895d: lea ecx, [ecx + eax + 0x7654] */
    esp -= 4u; WR32(esp, 0x4e8969u); FL41_CALL(0x4e29b7u); esp += 4u; esp += 4u;  /* 0x4e8964: call 0x4e29b7 */
    goto L_4e898b;  /* 0x4e8969: jmp 0x4e898b */
L_4e896b:
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4e896b: push 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e896d: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x822eu));  /* 0x4e8970: mov eax, dword ptr [edx + 0x822e] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x18fu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4e8976: imul eax, eax, 0x18f */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e897c: mov ecx, dword ptr [ebp - 4] */
    ecx = (uint32_t)(ecx + eax + 0x7654u);  /* 0x4e897f: lea ecx, [ecx + eax + 0x7654] */
    esp -= 4u; WR32(esp, 0x4e898bu); FL41_CALL(0x4e29b7u); esp += 4u; esp += 4u;  /* 0x4e8986: call 0x4e29b7 */
L_4e898b:
    goto L_4e885c;  /* 0x4e898b: jmp 0x4e885c */
L_4e8990:
    esp = ebp;  /* 0x4e8990: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4e8992: pop ebp */
    esp += 4u; goto done;  /* 0x4e8993: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4e9d8f (221 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4e9d8f_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4e9d8f: push ebp */
    ebp = esp;  /* 0x4e9d90: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x10u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4e9d92: sub esp, 0x10 */
    esp -= 4u; WR32(esp, esi);  /* 0x4e9d95: push esi */
    esp -= 4u; WR32(esp, edi);  /* 0x4e9d96: push edi */
    WR32((uint32_t)(ebp + 0xfffffff0u), ecx);  /* 0x4e9d97: mov dword ptr [ebp - 0x10], ecx */
    eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x4e9d9a: mov eax, dword ptr [ebp + 0xc] */
    ecx = RD32((uint32_t)(eax));  /* 0x4e9d9d: mov ecx, dword ptr [eax] */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4e9d9f: mov dword ptr [ebp - 4], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e9da2: mov edx, dword ptr [ebp - 4] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x23u)))) & 0xffffffffu;  /* 0x4e9da5: movsx eax, word ptr [edx + 0x23] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4e9da9: imul eax, eax, 0x22 */
    { uint32_t a_ = eax, b_ = 0x25u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4e9dac: add eax, 0x25 */
    WR16((uint32_t)(ebp + 0xfffffff8u), (eax & 0xffffu));  /* 0x4e9daf: mov word ptr [ebp - 8], ax */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4e9db3: movsx ecx, word ptr [ebp - 8] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4e9db7: push ecx */
    esp -= 4u; WR32(esp, 0x4e9dbdu); FL41_CALL(0x51dc43u); esp += 4u;  /* 0x4e9db8: call 0x51dc43 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4e9dbd: add esp, 4 */
    WR32((uint32_t)(ebp + 0xfffffff4u), eax);  /* 0x4e9dc0: mov dword ptr [ebp - 0xc], eax */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4e9dc3: mov edx, dword ptr [ebp + 8] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4e9dc6: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(edx), eax);  /* 0x4e9dc9: mov dword ptr [edx], eax */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffff4u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e9dcb: cmp dword ptr [ebp - 0xc], 0 */
    if (!zf) goto L_4e9e10;  /* 0x4e9dcf: jne 0x4e9e10 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x5c39e3u)))) & 0xffffffffu;  /* 0x4e9dd1: movsx ecx, word ptr [0x5c39e3] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4e9dd8: push ecx */
    edx = RD32((uint32_t)(0x5bb57bu));  /* 0x4e9dd9: mov edx, dword ptr [0x5bb57b] */
    esp -= 4u; WR32(esp, edx);  /* 0x4e9ddf: push edx */
    esp -= 4u; WR32(esp, 0x55ca38u);  /* 0x4e9de0: push 0x55ca38 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4e9de5: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4e9defu); FL41_CALL(0x50ca3eu); esp += 4u;  /* 0x4e9dea: call 0x50ca3e */
    { uint32_t a_ = esp, b_ = 0x10u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4e9def: add esp, 0x10 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4e9df2: push 0x63888b */
    esp -= 4u; WR32(esp, 0x55ca64u);  /* 0x4e9df7: push 0x55ca64 */
    ecx = 0x583979u;  /* 0x4e9dfc: mov ecx, 0x583979 */
    esp -= 4u; WR32(esp, 0x4e9e06u); FL41_CALL(0x42639du); esp += 8u; esp += 4u;  /* 0x4e9e01: call 0x42639d */
    ecx = 0x5cf659u;  /* 0x4e9e06: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4e9e10u); FL41_CALL(0x4c97b4u); esp += 4u;  /* 0x4e9e0b: call 0x4c97b4 */
L_4e9e10:
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4e9e10: movsx ecx, word ptr [ebp - 8] */
    eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x4e9e14: mov eax, dword ptr [ebp + 0xc] */
    esi = RD32((uint32_t)(eax));  /* 0x4e9e17: mov esi, dword ptr [eax] */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4e9e19: mov edx, dword ptr [ebp + 8] */
    edi = RD32((uint32_t)(edx));  /* 0x4e9e1c: mov edi, dword ptr [edx] */
    eax = ecx;  /* 0x4e9e1e: mov eax, ecx */
    { uint32_t a_ = ecx, n_ = 0x2u, r_; if (n_ != 0u) { FL41_SHR(r_, a_, n_, 32); ecx = r_; } }  /* 0x4e9e20: shr ecx, 2 */
    /* 0x4e9e23: rep movsd dword ptr es:[edi], dword ptr [esi] */
    while (ecx != 0u) {
    WR32(edi, RD32(esi));
    esi += 4u; edi += 4u;
    ecx -= 1u;
    }
    ecx = eax;  /* 0x4e9e25: mov ecx, eax */
    { uint32_t a_ = ecx, b_ = 0x3u, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x4e9e27: and ecx, 3 */
    /* 0x4e9e2a: rep movsb byte ptr es:[edi], byte ptr [esi] */
    while (ecx != 0u) {
    WR8(edi, RD8(esi));
    esi += 1u; edi += 1u;
    ecx -= 1u;
    }
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4e9e2c: movsx ecx, word ptr [ebp - 8] */
    edx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4e9e30: mov edx, dword ptr [ebp + 0x10] */
    eax = RD32((uint32_t)(edx));  /* 0x4e9e33: mov eax, dword ptr [edx] */
    { uint32_t a_ = eax, b_ = ecx, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4e9e35: add eax, ecx */
    ecx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4e9e37: mov ecx, dword ptr [ebp + 0x10] */
    WR32((uint32_t)(ecx), eax);  /* 0x4e9e3a: mov dword ptr [ecx], eax */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4e9e3c: movsx edx, word ptr [ebp - 8] */
    eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x4e9e40: mov eax, dword ptr [ebp + 0xc] */
    ecx = RD32((uint32_t)(eax));  /* 0x4e9e43: mov ecx, dword ptr [eax] */
    { uint32_t a_ = ecx, b_ = edx, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4e9e45: add ecx, edx */
    edx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4e9e47: mov edx, dword ptr [ebp + 0xc] */
    WR32((uint32_t)(edx), ecx);  /* 0x4e9e4a: mov dword ptr [edx], ecx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x63a4cdu)))) & 0xffffffffu;  /* 0x4e9e4c: movsx eax, word ptr [0x63a4cd] */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4e9e53: test eax, eax */
    if (zf) goto L_4e9e64;  /* 0x4e9e55: je 0x4e9e64 */
    esp -= 4u; WR32(esp, 0x55ca80u);  /* 0x4e9e57: push 0x55ca80 */
    esp -= 4u; WR32(esp, 0x4e9e61u); FL41_CALL(0x44a2b7u); esp += 4u;  /* 0x4e9e5c: call 0x44a2b7 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4e9e61: add esp, 4 */
L_4e9e64:
    edi = RD32(esp); esp += 4u;  /* 0x4e9e64: pop edi */
    esi = RD32(esp); esp += 4u;  /* 0x4e9e65: pop esi */
    esp = ebp;  /* 0x4e9e66: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4e9e68: pop ebp */
    esp += 16u; goto done;  /* 0x4e9e69: ret 0xc */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4ea3a0 (1836 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4ea3a0_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4ea3a0: push ebp */
    ebp = esp;  /* 0x4ea3a1: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x1cu, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4ea3a3: sub esp, 0x1c */
    esp -= 4u; WR32(esp, esi);  /* 0x4ea3a6: push esi */
    esp -= 4u; WR32(esp, edi);  /* 0x4ea3a7: push edi */
    WR32((uint32_t)(ebp + 0xffffffe8u), ecx);  /* 0x4ea3a8: mov dword ptr [ebp - 0x18], ecx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea3ab: movsx eax, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea3af: imul eax, eax, 0x8d */
    ecx = RD32((uint32_t)(eax + 0x5bb632u));  /* 0x4ea3b5: mov ecx, dword ptr [eax + 0x5bb632] */
    WR32((uint32_t)(ebp + 0xffffffe4u), ecx);  /* 0x4ea3bb: mov dword ptr [ebp - 0x1c], ecx */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xffffffe4u)), b_ = 0x3u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ea3be: cmp dword ptr [ebp - 0x1c], 3 */
    if ((!cf && !zf)) goto L_4eaac4;  /* 0x4ea3c2: ja 0x4eaac4 */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4ea3c8: mov edx, dword ptr [ebp - 0x1c] */
    /* 0x4ea3cb: jmp dword ptr [edx*4 + 0x4eaacc] */
    { uint32_t t_ = RD32((uint32_t)(edx * 4u + 0x4eaaccu));
    switch (t_) {
    case 0x4ea3d2u: goto L_4ea3d2;
    case 0x4ea40cu: goto L_4ea40c;
    case 0x4ea9c8u: goto L_4ea9c8;
    case 0x4eaaa5u: goto L_4eaaa5;
    default: FL41_TRAP;
    } }
L_4ea3d2:
    WR32((uint32_t)(0x5bb1cau), 0x1u);  /* 0x4ea3d2: mov dword ptr [0x5bb1ca], 1 */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea3dc: movsx eax, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea3e0: imul eax, eax, 0x8d */
    ecx = RD32((uint32_t)(eax + 0x5bb5e5u));  /* 0x4ea3e6: mov ecx, dword ptr [eax + 0x5bb5e5] */
    { uint32_t a_ = ecx, b_ = 0x2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4ea3ec: add ecx, 2 */
    esp -= 4u; WR32(esp, ecx);  /* 0x4ea3ef: push ecx */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea3f0: mov ecx, dword ptr [ebp - 0x18] */
    esp -= 4u; WR32(esp, 0x4ea3f8u); FL41_CALL(0x4ea1cbu); esp += 4u; esp += 4u;  /* 0x4ea3f3: call 0x4ea1cb */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea3f8: movsx edx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea3fc: imul edx, edx, 0x8d */
    WR32((uint32_t)(edx + 0x5bb632u), 0x1u);  /* 0x4ea402: mov dword ptr [edx + 0x5bb632], 1 */
L_4ea40c:
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea40c: movsx eax, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea410: imul eax, eax, 0x8d */
    WR32((uint32_t)(eax + 0x5bb626u), 0x0u);  /* 0x4ea416: mov dword ptr [eax + 0x5bb626], 0 */
    WR32((uint32_t)(0x5d1717u), 0x0u);  /* 0x4ea420: mov dword ptr [0x5d1717], 0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea42a: mov ecx, dword ptr [ebp - 0x18] */
    edx = RD32((uint32_t)(ecx + 0x699u));  /* 0x4ea42d: mov edx, dword ptr [ecx + 0x699] */
    WR32((uint32_t)(0x5d170bu), edx);  /* 0x4ea433: mov dword ptr [0x5d170b], edx */
    WR16((uint32_t)(0x5d171fu), 0x1u);  /* 0x4ea439: mov word ptr [0x5d171f], 1 */
    eax = RD32((uint32_t)(0x5bb587u));  /* 0x4ea442: mov eax, dword ptr [0x5bb587] */
    WR32((uint32_t)(ebp + 0xfffffff4u), eax);  /* 0x4ea447: mov dword ptr [ebp - 0xc], eax */
    ecx = RD32((uint32_t)(0x5bb58fu));  /* 0x4ea44a: mov ecx, dword ptr [0x5bb58f] */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4ea450: mov dword ptr [ebp - 4], ecx */
    edx = RD32((uint32_t)(0x5bb583u));  /* 0x4ea453: mov edx, dword ptr [0x5bb583] */
    WR32((uint32_t)(ebp + 0xfffffff0u), edx);  /* 0x4ea459: mov dword ptr [ebp - 0x10], edx */
    eax = RD32((uint32_t)(0x5bb58bu));  /* 0x4ea45c: mov eax, dword ptr [0x5bb58b] */
    WR32((uint32_t)(ebp + 0xfffffff8u), eax);  /* 0x4ea461: mov dword ptr [ebp - 8], eax */
    WR16((uint32_t)(ebp + 0xffffffecu), 0x0u);  /* 0x4ea464: mov word ptr [ebp - 0x14], 0 */
    goto L_4ea478;  /* 0x4ea46a: jmp 0x4ea478 */
L_4ea46c:
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xffffffecu))) & 0xffffu);  /* 0x4ea46c: mov cx, word ptr [ebp - 0x14] */
    { uint32_t a_ = (ecx & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); ecx = (ecx & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4ea470: add cx, 1 */
    WR16((uint32_t)(ebp + 0xffffffecu), (ecx & 0xffffu));  /* 0x4ea474: mov word ptr [ebp - 0x14], cx */
L_4ea478:
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea478: movsx edx, word ptr [ebp - 0x14] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea47c: movsx eax, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea480: imul eax, eax, 0x8d */
    ecx = RD32((uint32_t)(eax + 0x5bb5e5u));  /* 0x4ea486: mov ecx, dword ptr [eax + 0x5bb5e5] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0x23u)))) & 0xffffffffu;  /* 0x4ea48c: movsx eax, word ptr [ecx + 0x23] */
    { uint32_t a_ = edx, b_ = eax, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ea490: cmp edx, eax */
    if ((sf == of)) goto L_4ea9c3;  /* 0x4ea492: jge 0x4ea9c3 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea498: movsx ecx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea49c: imul ecx, ecx, 0x8d */
    edx = RD32((uint32_t)(ecx + 0x5bb5e5u));  /* 0x4ea4a2: mov edx, dword ptr [ecx + 0x5bb5e5] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea4a8: movsx eax, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea4ac: imul eax, eax, 0x22 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + eax + 0x25u)))) & 0xffffffffu;  /* 0x4ea4af: movsx ecx, word ptr [edx + eax + 0x25] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x5bb50bu)))) & 0xffffffffu;  /* 0x4ea4b4: movsx edx, word ptr [0x5bb50b] */
    { uint32_t a_ = ecx, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ea4bb: cmp ecx, edx */
    if (!zf) goto L_4ea9be;  /* 0x4ea4bd: jne 0x4ea9be */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea4c3: movsx eax, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea4c7: imul eax, eax, 0x8d */
    WR32((uint32_t)(eax + 0x5bb626u), 0x1u);  /* 0x4ea4cd: mov dword ptr [eax + 0x5bb626], 1 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea4d7: movsx ecx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea4db: imul ecx, ecx, 0x8d */
    edx = RD32((uint32_t)(ecx + 0x5bb5e5u));  /* 0x4ea4e1: mov edx, dword ptr [ecx + 0x5bb5e5] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea4e7: movsx eax, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea4eb: imul eax, eax, 0x22 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea4ee: movsx ecx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea4f2: imul ecx, ecx, 0x8d */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(edx + eax + 0x37u))) & 0xffffu);  /* 0x4ea4f8: mov dx, word ptr [edx + eax + 0x37] */
    WR16((uint32_t)(ecx + 0x5bb62au), (edx & 0xffffu));  /* 0x4ea4fd: mov word ptr [ecx + 0x5bb62a], dx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea504: movsx eax, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea508: imul eax, eax, 0x8d */
    ecx = RD32((uint32_t)(eax + 0x5bb5e5u));  /* 0x4ea50e: mov ecx, dword ptr [eax + 0x5bb5e5] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea514: movsx edx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea518: imul edx, edx, 0x22 */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea51b: movsx eax, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea51f: imul eax, eax, 0x8d */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(ecx + edx + 0x3bu))) & 0xffffu);  /* 0x4ea525: mov cx, word ptr [ecx + edx + 0x3b] */
    WR16((uint32_t)(eax + 0x5bb62cu), (ecx & 0xffffu));  /* 0x4ea52a: mov word ptr [eax + 0x5bb62c], cx */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea531: movsx edx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea535: imul edx, edx, 0x8d */
    eax = RD32((uint32_t)(edx + 0x5bb5e5u));  /* 0x4ea53b: mov eax, dword ptr [edx + 0x5bb5e5] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea541: movsx ecx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea545: imul ecx, ecx, 0x22 */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea548: movsx edx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea54c: imul edx, edx, 0x8d */
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(eax + ecx + 0x3fu))) & 0xffffu);  /* 0x4ea552: mov ax, word ptr [eax + ecx + 0x3f] */
    WR16((uint32_t)(edx + 0x5bb62eu), (eax & 0xffffu));  /* 0x4ea557: mov word ptr [edx + 0x5bb62e], ax */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea55e: movsx ecx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea562: imul ecx, ecx, 0x8d */
    edx = RD32((uint32_t)(ecx + 0x5bb5e5u));  /* 0x4ea568: mov edx, dword ptr [ecx + 0x5bb5e5] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea56e: movsx eax, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea572: imul eax, eax, 0x22 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea575: movsx ecx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea579: imul ecx, ecx, 0x8d */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(edx + eax + 0x43u))) & 0xffffu);  /* 0x4ea57f: mov dx, word ptr [edx + eax + 0x43] */
    WR16((uint32_t)(ecx + 0x5bb630u), (edx & 0xffffu));  /* 0x4ea584: mov word ptr [ecx + 0x5bb630], dx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea58b: movsx eax, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea58f: imul eax, eax, 0x8d */
    ecx = RD32((uint32_t)(eax + 0x5bb5e5u));  /* 0x4ea595: mov ecx, dword ptr [eax + 0x5bb5e5] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea59b: movsx edx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea59f: imul edx, edx, 0x22 */
    eax = RD32((uint32_t)(ecx + edx + 0x43u));  /* 0x4ea5a2: mov eax, dword ptr [ecx + edx + 0x43] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(ebp + 0xfffffffcu)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ea5a6: cmp eax, dword ptr [ebp - 4] */
    if ((!zf && sf == of)) goto L_4ea720;  /* 0x4ea5a9: jg 0x4ea720 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea5af: movsx ecx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea5b3: imul ecx, ecx, 0x8d */
    edx = RD32((uint32_t)(ecx + 0x5bb5e5u));  /* 0x4ea5b9: mov edx, dword ptr [ecx + 0x5bb5e5] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea5bf: movsx eax, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea5c3: imul eax, eax, 0x22 */
    ecx = RD32((uint32_t)(edx + eax + 0x3bu));  /* 0x4ea5c6: mov ecx, dword ptr [edx + eax + 0x3b] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(ebp + 0xfffffff4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ea5ca: cmp ecx, dword ptr [ebp - 0xc] */
    if ((sf != of)) goto L_4ea720;  /* 0x4ea5cd: jl 0x4ea720 */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea5d3: movsx edx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea5d7: imul edx, edx, 0x8d */
    eax = RD32((uint32_t)(edx + 0x5bb5e5u));  /* 0x4ea5dd: mov eax, dword ptr [edx + 0x5bb5e5] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea5e3: movsx ecx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea5e7: imul ecx, ecx, 0x22 */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea5ea: mov edx, dword ptr [ebp - 0x18] */
    eax = RD32((uint32_t)(eax + ecx + 0x2bu));  /* 0x4ea5ed: mov eax, dword ptr [eax + ecx + 0x2b] */
    WR32((uint32_t)(edx + 0x826au), eax);  /* 0x4ea5f1: mov dword ptr [edx + 0x826a], eax */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea5f7: movsx ecx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea5fb: imul ecx, ecx, 0x8d */
    edx = RD32((uint32_t)(ecx + 0x5bb5e5u));  /* 0x4ea601: mov edx, dword ptr [ecx + 0x5bb5e5] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea607: movsx eax, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea60b: imul eax, eax, 0x22 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea60e: mov ecx, dword ptr [ebp - 0x18] */
    edx = RD32((uint32_t)(edx + eax + 0x33u));  /* 0x4ea611: mov edx, dword ptr [edx + eax + 0x33] */
    WR32((uint32_t)(ecx + 0x8272u), edx);  /* 0x4ea615: mov dword ptr [ecx + 0x8272], edx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea61b: movsx eax, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea61f: imul eax, eax, 0x8d */
    ecx = RD32((uint32_t)(eax + 0x5bb5e5u));  /* 0x4ea625: mov ecx, dword ptr [eax + 0x5bb5e5] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea62b: movsx edx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea62f: imul edx, edx, 0x22 */
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea632: mov eax, dword ptr [ebp - 0x18] */
    ecx = RD32((uint32_t)(ecx + edx + 0x27u));  /* 0x4ea635: mov ecx, dword ptr [ecx + edx + 0x27] */
    WR32((uint32_t)(eax + 0x8266u), ecx);  /* 0x4ea639: mov dword ptr [eax + 0x8266], ecx */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea63f: movsx edx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea643: imul edx, edx, 0x8d */
    eax = RD32((uint32_t)(edx + 0x5bb5e5u));  /* 0x4ea649: mov eax, dword ptr [edx + 0x5bb5e5] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea64f: movsx ecx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea653: imul ecx, ecx, 0x22 */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea656: mov edx, dword ptr [ebp - 0x18] */
    eax = RD32((uint32_t)(eax + ecx + 0x2fu));  /* 0x4ea659: mov eax, dword ptr [eax + ecx + 0x2f] */
    WR32((uint32_t)(edx + 0x826eu), eax);  /* 0x4ea65d: mov dword ptr [edx + 0x826e], eax */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea663: movsx ecx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea667: imul ecx, ecx, 0x8d */
    edx = RD32((uint32_t)(ecx + 0x5bb5e5u));  /* 0x4ea66d: mov edx, dword ptr [ecx + 0x5bb5e5] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea673: movsx eax, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea677: imul eax, eax, 0x22 */
    ecx = RD32((uint32_t)(edx + eax + 0x3bu));  /* 0x4ea67a: mov ecx, dword ptr [edx + eax + 0x3b] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(ebp + 0xfffffff4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4ea67e: sub ecx, dword ptr [ebp - 0xc] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4ea681: add ecx, dword ptr [0x58318a] */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea687: mov edx, dword ptr [ebp - 0x18] */
    WR32((uint32_t)(edx + 0x827au), ecx);  /* 0x4ea68a: mov dword ptr [edx + 0x827a], ecx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea690: movsx eax, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea694: imul eax, eax, 0x8d */
    ecx = RD32((uint32_t)(eax + 0x5bb5e5u));  /* 0x4ea69a: mov ecx, dword ptr [eax + 0x5bb5e5] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea6a0: movsx edx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea6a4: imul edx, edx, 0x22 */
    eax = RD32((uint32_t)(ecx + edx + 0x43u));  /* 0x4ea6a7: mov eax, dword ptr [ecx + edx + 0x43] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(ebp + 0xfffffff4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4ea6ab: sub eax, dword ptr [ebp - 0xc] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4ea6ae: add eax, dword ptr [0x58318a] */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea6b4: mov ecx, dword ptr [ebp - 0x18] */
    WR32((uint32_t)(ecx + 0x8282u), eax);  /* 0x4ea6b7: mov dword ptr [ecx + 0x8282], eax */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea6bd: movsx edx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea6c1: imul edx, edx, 0x8d */
    eax = RD32((uint32_t)(edx + 0x5bb5e5u));  /* 0x4ea6c7: mov eax, dword ptr [edx + 0x5bb5e5] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea6cd: movsx ecx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea6d1: imul ecx, ecx, 0x22 */
    edx = RD32((uint32_t)(eax + ecx + 0x37u));  /* 0x4ea6d4: mov edx, dword ptr [eax + ecx + 0x37] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4ea6d8: add edx, dword ptr [0x583186] */
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea6de: mov eax, dword ptr [ebp - 0x18] */
    WR32((uint32_t)(eax + 0x8276u), edx);  /* 0x4ea6e1: mov dword ptr [eax + 0x8276], edx */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea6e7: movsx ecx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea6eb: imul ecx, ecx, 0x8d */
    edx = RD32((uint32_t)(ecx + 0x5bb5e5u));  /* 0x4ea6f1: mov edx, dword ptr [ecx + 0x5bb5e5] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea6f7: movsx eax, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea6fb: imul eax, eax, 0x22 */
    ecx = RD32((uint32_t)(edx + eax + 0x3fu));  /* 0x4ea6fe: mov ecx, dword ptr [edx + eax + 0x3f] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4ea702: add ecx, dword ptr [0x583186] */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea708: mov edx, dword ptr [ebp - 0x18] */
    WR32((uint32_t)(edx + 0x827eu), ecx);  /* 0x4ea70b: mov dword ptr [edx + 0x827e], ecx */
    WR32((uint32_t)(0x5d1717u), 0x1u);  /* 0x4ea711: mov dword ptr [0x5d1717], 1 */
    goto L_4ea9bc;  /* 0x4ea71b: jmp 0x4ea9bc */
L_4ea720:
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea720: movsx eax, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea724: imul eax, eax, 0x8d */
    ecx = RD32((uint32_t)(eax + 0x5bb5e5u));  /* 0x4ea72a: mov ecx, dword ptr [eax + 0x5bb5e5] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea730: movsx edx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea734: imul edx, edx, 0x22 */
    eax = RD32((uint32_t)(ecx + edx + 0x3bu));  /* 0x4ea737: mov eax, dword ptr [ecx + edx + 0x3b] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(ebp + 0xfffffffcu)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ea73b: cmp eax, dword ptr [ebp - 4] */
    if ((!zf && sf == of)) goto L_4ea760;  /* 0x4ea73e: jg 0x4ea760 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea740: movsx ecx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea744: imul ecx, ecx, 0x8d */
    edx = RD32((uint32_t)(ecx + 0x5bb5e5u));  /* 0x4ea74a: mov edx, dword ptr [ecx + 0x5bb5e5] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea750: movsx eax, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea754: imul eax, eax, 0x22 */
    ecx = RD32((uint32_t)(edx + eax + 0x43u));  /* 0x4ea757: mov ecx, dword ptr [edx + eax + 0x43] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(ebp + 0xfffffffcu)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ea75b: cmp ecx, dword ptr [ebp - 4] */
    if ((sf == of)) goto L_4ea7a8;  /* 0x4ea75e: jge 0x4ea7a8 */
L_4ea760:
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea760: movsx edx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea764: imul edx, edx, 0x8d */
    eax = RD32((uint32_t)(edx + 0x5bb5e5u));  /* 0x4ea76a: mov eax, dword ptr [edx + 0x5bb5e5] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea770: movsx ecx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea774: imul ecx, ecx, 0x22 */
    edx = RD32((uint32_t)(eax + ecx + 0x3bu));  /* 0x4ea777: mov edx, dword ptr [eax + ecx + 0x3b] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ebp + 0xfffffff4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ea77b: cmp edx, dword ptr [ebp - 0xc] */
    if ((!zf && sf == of)) goto L_4ea9bc;  /* 0x4ea77e: jg 0x4ea9bc */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea784: movsx eax, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea788: imul eax, eax, 0x8d */
    ecx = RD32((uint32_t)(eax + 0x5bb5e5u));  /* 0x4ea78e: mov ecx, dword ptr [eax + 0x5bb5e5] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea794: movsx edx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea798: imul edx, edx, 0x22 */
    eax = RD32((uint32_t)(ecx + edx + 0x43u));  /* 0x4ea79b: mov eax, dword ptr [ecx + edx + 0x43] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(ebp + 0xfffffff4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ea79f: cmp eax, dword ptr [ebp - 0xc] */
    if ((sf != of)) goto L_4ea9bc;  /* 0x4ea7a2: jl 0x4ea9bc */
L_4ea7a8:
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea7a8: movsx ecx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea7ac: imul ecx, ecx, 0x8d */
    edx = RD32((uint32_t)(ecx + 0x5bb5e5u));  /* 0x4ea7b2: mov edx, dword ptr [ecx + 0x5bb5e5] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea7b8: movsx eax, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea7bc: imul eax, eax, 0x22 */
    ecx = RD32((uint32_t)(edx + eax + 0x3bu));  /* 0x4ea7bf: mov ecx, dword ptr [edx + eax + 0x3b] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(ebp + 0xfffffff4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ea7c3: cmp ecx, dword ptr [ebp - 0xc] */
    if ((sf == of)) goto L_4ea7d6;  /* 0x4ea7c6: jge 0x4ea7d6 */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea7c8: mov edx, dword ptr [ebp - 0x18] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4ea7cb: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(edx + 0x827au), eax);  /* 0x4ea7ce: mov dword ptr [edx + 0x827a], eax */
    goto L_4ea7fa;  /* 0x4ea7d4: jmp 0x4ea7fa */
L_4ea7d6:
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea7d6: movsx ecx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea7da: imul ecx, ecx, 0x8d */
    edx = RD32((uint32_t)(ecx + 0x5bb5e5u));  /* 0x4ea7e0: mov edx, dword ptr [ecx + 0x5bb5e5] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea7e6: movsx eax, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea7ea: imul eax, eax, 0x22 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea7ed: mov ecx, dword ptr [ebp - 0x18] */
    edx = RD32((uint32_t)(edx + eax + 0x3bu));  /* 0x4ea7f0: mov edx, dword ptr [edx + eax + 0x3b] */
    WR32((uint32_t)(ecx + 0x827au), edx);  /* 0x4ea7f4: mov dword ptr [ecx + 0x827a], edx */
L_4ea7fa:
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea7fa: movsx eax, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea7fe: imul eax, eax, 0x8d */
    ecx = RD32((uint32_t)(eax + 0x5bb5e5u));  /* 0x4ea804: mov ecx, dword ptr [eax + 0x5bb5e5] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea80a: movsx edx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea80e: imul edx, edx, 0x22 */
    eax = RD32((uint32_t)(ecx + edx + 0x43u));  /* 0x4ea811: mov eax, dword ptr [ecx + edx + 0x43] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(ebp + 0xfffffffcu)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ea815: cmp eax, dword ptr [ebp - 4] */
    if ((zf || sf != of)) goto L_4ea828;  /* 0x4ea818: jle 0x4ea828 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea81a: mov ecx, dword ptr [ebp - 0x18] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ea81d: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x8282u), edx);  /* 0x4ea820: mov dword ptr [ecx + 0x8282], edx */
    goto L_4ea84c;  /* 0x4ea826: jmp 0x4ea84c */
L_4ea828:
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea828: movsx eax, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea82c: imul eax, eax, 0x8d */
    ecx = RD32((uint32_t)(eax + 0x5bb5e5u));  /* 0x4ea832: mov ecx, dword ptr [eax + 0x5bb5e5] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea838: movsx edx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea83c: imul edx, edx, 0x22 */
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea83f: mov eax, dword ptr [ebp - 0x18] */
    ecx = RD32((uint32_t)(ecx + edx + 0x43u));  /* 0x4ea842: mov ecx, dword ptr [ecx + edx + 0x43] */
    WR32((uint32_t)(eax + 0x8282u), ecx);  /* 0x4ea846: mov dword ptr [eax + 0x8282], ecx */
L_4ea84c:
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea84c: movsx edx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea850: imul edx, edx, 0x8d */
    eax = RD32((uint32_t)(edx + 0x5bb5e5u));  /* 0x4ea856: mov eax, dword ptr [edx + 0x5bb5e5] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea85c: movsx ecx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea860: imul ecx, ecx, 0x22 */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea863: movsx edx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea867: imul edx, edx, 0x8d */
    edx = RD32((uint32_t)(edx + 0x5bb5e5u));  /* 0x4ea86d: mov edx, dword ptr [edx + 0x5bb5e5] */
    esi = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea873: movsx esi, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(esi) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); esi = r_; }  /* 0x4ea877: imul esi, esi, 0x22 */
    edi = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea87a: mov edi, dword ptr [ebp - 0x18] */
    edi = RD32((uint32_t)(edi + 0x827au));  /* 0x4ea87d: mov edi, dword ptr [edi + 0x827a] */
    { uint32_t a_ = edi, b_ = RD32((uint32_t)(edx + esi + 0x3bu)), r_; FL41_SUB(a_, b_, 0u, r_, 32); edi = r_; }  /* 0x4ea883: sub edi, dword ptr [edx + esi + 0x3b] */
    eax = RD32((uint32_t)(eax + ecx + 0x2bu));  /* 0x4ea887: mov eax, dword ptr [eax + ecx + 0x2b] */
    { uint32_t a_ = eax, b_ = edi, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4ea88b: add eax, edi */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea88d: mov ecx, dword ptr [ebp - 0x18] */
    WR32((uint32_t)(ecx + 0x826au), eax);  /* 0x4ea890: mov dword ptr [ecx + 0x826a], eax */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea896: movsx edx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea89a: imul edx, edx, 0x8d */
    eax = RD32((uint32_t)(edx + 0x5bb5e5u));  /* 0x4ea8a0: mov eax, dword ptr [edx + 0x5bb5e5] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea8a6: movsx ecx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea8aa: imul ecx, ecx, 0x22 */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea8ad: movsx edx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea8b1: imul edx, edx, 0x8d */
    edx = RD32((uint32_t)(edx + 0x5bb5e5u));  /* 0x4ea8b7: mov edx, dword ptr [edx + 0x5bb5e5] */
    esi = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea8bd: movsx esi, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(esi) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); esi = r_; }  /* 0x4ea8c1: imul esi, esi, 0x22 */
    edi = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea8c4: mov edi, dword ptr [ebp - 0x18] */
    edx = RD32((uint32_t)(edx + esi + 0x43u));  /* 0x4ea8c7: mov edx, dword ptr [edx + esi + 0x43] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(edi + 0x8282u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4ea8cb: sub edx, dword ptr [edi + 0x8282] */
    eax = RD32((uint32_t)(eax + ecx + 0x33u));  /* 0x4ea8d1: mov eax, dword ptr [eax + ecx + 0x33] */
    { uint32_t a_ = eax, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4ea8d5: sub eax, edx */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea8d7: mov ecx, dword ptr [ebp - 0x18] */
    WR32((uint32_t)(ecx + 0x8272u), eax);  /* 0x4ea8da: mov dword ptr [ecx + 0x8272], eax */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea8e0: movsx edx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea8e4: imul edx, edx, 0x8d */
    eax = RD32((uint32_t)(edx + 0x5bb5e5u));  /* 0x4ea8ea: mov eax, dword ptr [edx + 0x5bb5e5] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea8f0: movsx ecx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea8f4: imul ecx, ecx, 0x22 */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea8f7: mov edx, dword ptr [ebp - 0x18] */
    eax = RD32((uint32_t)(eax + ecx + 0x27u));  /* 0x4ea8fa: mov eax, dword ptr [eax + ecx + 0x27] */
    WR32((uint32_t)(edx + 0x8266u), eax);  /* 0x4ea8fe: mov dword ptr [edx + 0x8266], eax */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea904: movsx ecx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea908: imul ecx, ecx, 0x8d */
    edx = RD32((uint32_t)(ecx + 0x5bb5e5u));  /* 0x4ea90e: mov edx, dword ptr [ecx + 0x5bb5e5] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea914: movsx eax, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea918: imul eax, eax, 0x22 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea91b: mov ecx, dword ptr [ebp - 0x18] */
    edx = RD32((uint32_t)(edx + eax + 0x2fu));  /* 0x4ea91e: mov edx, dword ptr [edx + eax + 0x2f] */
    WR32((uint32_t)(ecx + 0x826eu), edx);  /* 0x4ea922: mov dword ptr [ecx + 0x826e], edx */
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea928: mov eax, dword ptr [ebp - 0x18] */
    ecx = RD32((uint32_t)(eax + 0x827au));  /* 0x4ea92b: mov ecx, dword ptr [eax + 0x827a] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(ebp + 0xfffffff4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4ea931: sub ecx, dword ptr [ebp - 0xc] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4ea934: add ecx, dword ptr [0x58318a] */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea93a: mov edx, dword ptr [ebp - 0x18] */
    WR32((uint32_t)(edx + 0x827au), ecx);  /* 0x4ea93d: mov dword ptr [edx + 0x827a], ecx */
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea943: mov eax, dword ptr [ebp - 0x18] */
    ecx = RD32((uint32_t)(eax + 0x8282u));  /* 0x4ea946: mov ecx, dword ptr [eax + 0x8282] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(ebp + 0xfffffff4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4ea94c: sub ecx, dword ptr [ebp - 0xc] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4ea94f: add ecx, dword ptr [0x58318a] */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea955: mov edx, dword ptr [ebp - 0x18] */
    WR32((uint32_t)(edx + 0x8282u), ecx);  /* 0x4ea958: mov dword ptr [edx + 0x8282], ecx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea95e: movsx eax, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ea962: imul eax, eax, 0x8d */
    ecx = RD32((uint32_t)(eax + 0x5bb5e5u));  /* 0x4ea968: mov ecx, dword ptr [eax + 0x5bb5e5] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea96e: movsx edx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea972: imul edx, edx, 0x22 */
    eax = RD32((uint32_t)(ecx + edx + 0x37u));  /* 0x4ea975: mov eax, dword ptr [ecx + edx + 0x37] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4ea979: add eax, dword ptr [0x583186] */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea97f: mov ecx, dword ptr [ebp - 0x18] */
    WR32((uint32_t)(ecx + 0x8276u), eax);  /* 0x4ea982: mov dword ptr [ecx + 0x8276], eax */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea988: movsx edx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ea98c: imul edx, edx, 0x8d */
    eax = RD32((uint32_t)(edx + 0x5bb5e5u));  /* 0x4ea992: mov eax, dword ptr [edx + 0x5bb5e5] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xffffffecu)))) & 0xffffffffu;  /* 0x4ea998: movsx ecx, word ptr [ebp - 0x14] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x22u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea99c: imul ecx, ecx, 0x22 */
    edx = RD32((uint32_t)(eax + ecx + 0x3fu));  /* 0x4ea99f: mov edx, dword ptr [eax + ecx + 0x3f] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4ea9a3: add edx, dword ptr [0x583186] */
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea9a9: mov eax, dword ptr [ebp - 0x18] */
    WR32((uint32_t)(eax + 0x827eu), edx);  /* 0x4ea9ac: mov dword ptr [eax + 0x827e], edx */
    WR32((uint32_t)(0x5d1717u), 0x1u);  /* 0x4ea9b2: mov dword ptr [0x5d1717], 1 */
L_4ea9bc:
    goto L_4ea9c3;  /* 0x4ea9bc: jmp 0x4ea9c3 */
L_4ea9be:
    goto L_4ea46c;  /* 0x4ea9be: jmp 0x4ea46c */
L_4ea9c3:
    goto L_4eaac4;  /* 0x4ea9c3: jmp 0x4eaac4 */
L_4ea9c8:
    esp -= 4u; WR32(esp, 0x17u);  /* 0x4ea9c8: push 0x17 */
    ecx = 0x5c3a67u;  /* 0x4ea9ca: mov ecx, 0x5c3a67 */
    esp -= 4u; WR32(esp, 0x4ea9d4u); FL41_CALL(0x4fb2e3u); esp += 4u; esp += 4u;  /* 0x4ea9cf: call 0x4fb2e3 */
    esp -= 4u; WR32(esp, 0x1u);  /* 0x4ea9d4: push 1 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea9d6: movsx ecx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea9da: imul ecx, ecx, 0x8d */
    edx = RD32((uint32_t)(ecx + 0x5bb5e5u));  /* 0x4ea9e0: mov edx, dword ptr [ecx + 0x5bb5e5] */
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(edx))) & 0xffffu);  /* 0x4ea9e6: mov ax, word ptr [edx] */
    esp -= 4u; WR32(esp, eax);  /* 0x4ea9e9: push eax */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4ea9ea: mov ecx, dword ptr [ebp - 0x18] */
    esp -= 4u; WR32(esp, 0x4ea9f2u); FL41_CALL(0x4e9e84u); esp += 8u; esp += 4u;  /* 0x4ea9ed: call 0x4e9e84 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ea9f2: movsx ecx, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ea9f6: imul ecx, ecx, 0x8d */
    WR32((uint32_t)(ecx + 0x5bb626u), 0x0u);  /* 0x4ea9fc: mov dword ptr [ecx + 0x5bb626], 0 */
    edx = RD32((uint32_t)(0x5d03bbu));  /* 0x4eaa06: mov edx, dword ptr [0x5d03bb] */
    WR32((uint32_t)(0x5d170bu), edx);  /* 0x4eaa0c: mov dword ptr [0x5d170b], edx */
    WR16((uint32_t)(0x5d171fu), 0x1u);  /* 0x4eaa12: mov word ptr [0x5d171f], 1 */
    WR32((uint32_t)(0x5d1717u), 0x1u);  /* 0x4eaa1b: mov dword ptr [0x5d1717], 1 */
    ecx = 0x5830ceu;  /* 0x4eaa25: mov ecx, 0x5830ce */
    esp -= 4u; WR32(esp, 0x4eaa2fu); FL41_CALL(0x4db870u); esp += 4u;  /* 0x4eaa2a: call 0x4db870 */
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4eaa2f: mov eax, dword ptr [ebp - 0x18] */
    ecx = RD32((uint32_t)(eax + 0x827au));  /* 0x4eaa32: mov ecx, dword ptr [eax + 0x827a] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4eaa38: sub ecx, dword ptr [0x58318a] */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4eaa3e: mov edx, dword ptr [ebp - 0x18] */
    WR32((uint32_t)(edx + 0x826au), ecx);  /* 0x4eaa41: mov dword ptr [edx + 0x826a], ecx */
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4eaa47: mov eax, dword ptr [ebp - 0x18] */
    ecx = RD32((uint32_t)(eax + 0x8282u));  /* 0x4eaa4a: mov ecx, dword ptr [eax + 0x8282] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4eaa50: sub ecx, dword ptr [0x58318a] */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4eaa56: mov edx, dword ptr [ebp - 0x18] */
    WR32((uint32_t)(edx + 0x8272u), ecx);  /* 0x4eaa59: mov dword ptr [edx + 0x8272], ecx */
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4eaa5f: mov eax, dword ptr [ebp - 0x18] */
    ecx = RD32((uint32_t)(eax + 0x8276u));  /* 0x4eaa62: mov ecx, dword ptr [eax + 0x8276] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4eaa68: sub ecx, dword ptr [0x583186] */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4eaa6e: mov edx, dword ptr [ebp - 0x18] */
    WR32((uint32_t)(edx + 0x8266u), ecx);  /* 0x4eaa71: mov dword ptr [edx + 0x8266], ecx */
    eax = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4eaa77: mov eax, dword ptr [ebp - 0x18] */
    ecx = RD32((uint32_t)(eax + 0x827eu));  /* 0x4eaa7a: mov ecx, dword ptr [eax + 0x827e] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4eaa80: sub ecx, dword ptr [0x583186] */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4eaa86: mov edx, dword ptr [ebp - 0x18] */
    WR32((uint32_t)(edx + 0x826eu), ecx);  /* 0x4eaa89: mov dword ptr [edx + 0x826e], ecx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4eaa8f: movsx eax, word ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4eaa93: imul eax, eax, 0x8d */
    WR32((uint32_t)(eax + 0x5bb632u), 0x3u);  /* 0x4eaa99: mov dword ptr [eax + 0x5bb632], 3 */
    goto L_4eaac4;  /* 0x4eaaa3: jmp 0x4eaac4 */
L_4eaaa5:
    WR32((uint32_t)(0x5d1717u), 0x0u);  /* 0x4eaaa5: mov dword ptr [0x5d1717], 0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x4eaaaf: mov ecx, dword ptr [ebp - 0x18] */
    esp -= 4u; WR32(esp, 0x4eaab7u); FL41_CALL(0x4ea229u); esp += 4u;  /* 0x4eaab2: call 0x4ea229 */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0x8u))) & 0xffffu);  /* 0x4eaab7: mov cx, word ptr [ebp + 8] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4eaabb: push ecx */
    esp -= 4u; WR32(esp, 0x4eaac1u); FL41_CALL(0x42ba3au); esp += 4u;  /* 0x4eaabc: call 0x42ba3a */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4eaac1: add esp, 4 */
L_4eaac4:
    edi = RD32(esp); esp += 4u;  /* 0x4eaac4: pop edi */
    esi = RD32(esp); esp += 4u;  /* 0x4eaac5: pop esi */
    esp = ebp;  /* 0x4eaac6: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4eaac8: pop ebp */
    esp += 8u; goto done;  /* 0x4eaac9: ret 4 */
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

/* GAME.EXE 0x4ef2d1 (284 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4ef2d1_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4ef2d1: push ebp */
    ebp = esp;  /* 0x4ef2d2: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4ef2d4: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4ef2d5: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ef2d8: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x19au), 0x0u);  /* 0x4ef2db: mov dword ptr [eax + 0x19a], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ef2e5: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(ecx + 0x10u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ef2e8: cmp dword ptr [ecx + 0x10], 0 */
    if (zf) goto L_4ef304;  /* 0x4ef2ec: je 0x4ef304 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ef2ee: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(edx + 0x10u)), b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ef2f1: cmp dword ptr [edx + 0x10], 1 */
    if (zf) goto L_4ef304;  /* 0x4ef2f5: je 0x4ef304 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ef2f7: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x10u)), b_ = 0x2u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ef2fa: cmp dword ptr [eax + 0x10], 2 */
    if (!zf) goto L_4ef3e5;  /* 0x4ef2fe: jne 0x4ef3e5 */
L_4ef304:
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xcu)))) & 0xffffffffu;  /* 0x4ef304: movsx ecx, word ptr [ebp + 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ef308: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x142u));  /* 0x4ef30b: mov eax, dword ptr [edx + 0x142] */
    { uint32_t a_ = eax, b_ = 0x5u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4ef311: add eax, 5 */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ef314: cmp ecx, eax */
    if ((sf != of)) goto L_4ef3db;  /* 0x4ef316: jl 0x4ef3db */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xcu)))) & 0xffffffffu;  /* 0x4ef31c: movsx ecx, word ptr [ebp + 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ef320: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x14au));  /* 0x4ef323: mov eax, dword ptr [edx + 0x14a] */
    { uint32_t a_ = eax, b_ = 0xau, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4ef329: add eax, 0xa */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ef32c: cmp ecx, eax */
    if ((!zf && sf == of)) goto L_4ef3db;  /* 0x4ef32e: jg 0x4ef3db */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ef334: movsx ecx, word ptr [ebp + 8] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ef338: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x13eu));  /* 0x4ef33b: mov eax, dword ptr [edx + 0x13e] */
    { uint32_t a_ = eax, b_ = 0x5u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4ef341: add eax, 5 */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ef344: cmp ecx, eax */
    if ((sf != of)) goto L_4ef3db;  /* 0x4ef346: jl 0x4ef3db */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ef34c: movsx ecx, word ptr [ebp + 8] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ef350: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x146u));  /* 0x4ef353: mov eax, dword ptr [edx + 0x146] */
    { uint32_t a_ = eax, b_ = 0x5u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4ef359: add eax, 5 */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ef35c: cmp ecx, eax */
    if ((!zf && sf == of)) goto L_4ef3db;  /* 0x4ef35e: jg 0x4ef3db */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ef360: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x19au), 0x1u);  /* 0x4ef363: mov dword ptr [ecx + 0x19a], 1 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ef36d: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(edx + 0x10u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ef370: cmp dword ptr [edx + 0x10], 0 */
    if (!zf) goto L_4ef38c;  /* 0x4ef374: jne 0x4ef38c */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ef376: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0xc2u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ef379: cmp dword ptr [eax + 0xc2], 0 */
    if (zf) goto L_4ef38c;  /* 0x4ef380: je 0x4ef38c */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ef382: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x10u), 0x1u);  /* 0x4ef385: mov dword ptr [ecx + 0x10], 1 */
L_4ef38c:
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ef38c: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(edx + 0xcau)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4ef38f: cmp dword ptr [edx + 0xca], 0 */
    if (zf) goto L_4ef3d4;  /* 0x4ef396: je 0x4ef3d4 */
    WR32((uint32_t)(0x5c39e5u), 0x27d9u);  /* 0x4ef398: mov dword ptr [0x5c39e5], 0x27d9 */
    WR32((uint32_t)(0x5b44f4u), 0x1u);  /* 0x4ef3a2: mov dword ptr [0x5b44f4], 1 */
    eax = RD32((uint32_t)(0x5b44f0u));  /* 0x4ef3ac: mov eax, dword ptr [0x5b44f0] */
    { uint32_t a_ = eax, n_ = 0x5u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); eax = r_; } }  /* 0x4ef3b1: shl eax, 5 */
    ecx = RD32((uint32_t)(0x5b44f4u));  /* 0x4ef3b4: mov ecx, dword ptr [0x5b44f4] */
    { uint32_t a_ = ecx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); ecx = r_; } }  /* 0x4ef3ba: shl ecx, 4 */
    edx = (uint32_t)(eax + ecx + 0x5b160cu);  /* 0x4ef3bd: lea edx, [eax + ecx + 0x5b160c] */
    WR32((uint32_t)(0x5d1631u), edx);  /* 0x4ef3c4: mov dword ptr [0x5d1631], edx */
    WR32((uint32_t)(0x5d1639u), 0x1u);  /* 0x4ef3ca: mov dword ptr [0x5d1639], 1 */
L_4ef3d4:
    eax = 0x1u;  /* 0x4ef3d4: mov eax, 1 */
    goto L_4ef3e7;  /* 0x4ef3d9: jmp 0x4ef3e7 */
L_4ef3db:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ef3db: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x10u), 0x0u);  /* 0x4ef3de: mov dword ptr [eax + 0x10], 0 */
L_4ef3e5:
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4ef3e5: xor eax, eax */
L_4ef3e7:
    esp = ebp;  /* 0x4ef3e7: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4ef3e9: pop ebp */
    esp += 12u; goto done;  /* 0x4ef3ea: ret 8 */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4f6624 (410 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4f6624_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4f6624: push ebp */
    ebp = esp;  /* 0x4f6625: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x8u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4f6627: sub esp, 8 */
    WR32((uint32_t)(ebp + 0xfffffff8u), ecx);  /* 0x4f662a: mov dword ptr [ebp - 8], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4f662d: mov eax, dword ptr [ebp - 8] */
    WR32((uint32_t)(eax + 0x3c2u), 0x3e8u);  /* 0x4f6630: mov dword ptr [eax + 0x3c2], 0x3e8 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4f663a: mov ecx, dword ptr [ebp - 8] */
    esp -= 4u; WR32(esp, 0x4f6642u); FL41_CALL(0x4f709cu); esp += 4u;  /* 0x4f663d: call 0x4f709c */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4f6642: test eax, eax */
    if (!zf) goto L_4f666e;  /* 0x4f6644: jne 0x4f666e */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4f6646: mov ecx, dword ptr [ebp - 8] */
    WR32((uint32_t)(ecx + 0x3c2u), 0x3eau);  /* 0x4f6649: mov dword ptr [ecx + 0x3c2], 0x3ea */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4f6653: mov edx, dword ptr [ebp - 8] */
    WR32((uint32_t)(edx + 0x3beu), 0x0u);  /* 0x4f6656: mov dword ptr [edx + 0x3be], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4f6660: mov eax, dword ptr [ebp - 8] */
    eax = RD32((uint32_t)(eax + 0x3beu));  /* 0x4f6663: mov eax, dword ptr [eax + 0x3be] */
    goto L_4f67b8;  /* 0x4f6669: jmp 0x4f67b8 */
L_4f666e:
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4f666e: mov ecx, dword ptr [ebp + 8] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x5bbu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4f6671: imul ecx, ecx, 0x5bb */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4f6677: mov edx, dword ptr [ebp - 8] */
    eax = RD32((uint32_t)(edx + 0x3ceu));  /* 0x4f667a: mov eax, dword ptr [edx + 0x3ce] */
    { uint32_t a_ = eax, b_ = ecx, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4f6680: add eax, ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), eax);  /* 0x4f6682: mov dword ptr [ebp - 4], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4f6685: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(ecx + 0x162u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4f6688: cmp dword ptr [ecx + 0x162], 0 */
    if (zf) goto L_4f669d;  /* 0x4f668f: je 0x4f669d */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4f6691: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(edx + 0x28fu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4f6694: cmp dword ptr [edx + 0x28f], 0 */
    if (!zf) goto L_4f66c5;  /* 0x4f669b: jne 0x4f66c5 */
L_4f669d:
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4f669d: mov eax, dword ptr [ebp - 8] */
    WR32((uint32_t)(eax + 0x3c2u), 0x3efu);  /* 0x4f66a0: mov dword ptr [eax + 0x3c2], 0x3ef */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4f66aa: mov ecx, dword ptr [ebp - 8] */
    WR32((uint32_t)(ecx + 0x3beu), 0x0u);  /* 0x4f66ad: mov dword ptr [ecx + 0x3be], 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4f66b7: mov edx, dword ptr [ebp - 8] */
    eax = RD32((uint32_t)(edx + 0x3beu));  /* 0x4f66ba: mov eax, dword ptr [edx + 0x3be] */
    goto L_4f67b8;  /* 0x4f66c0: jmp 0x4f67b8 */
L_4f66c5:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4f66c5: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x16eu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4f66c8: cmp dword ptr [eax + 0x16e], 0 */
    if (zf) goto L_4f6795;  /* 0x4f66cf: je 0x4f6795 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4f66d5: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x172u));  /* 0x4f66d8: mov edx, dword ptr [ecx + 0x172] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ebp + 0xcu)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4f66de: cmp edx, dword ptr [ebp + 0xc] */
    if (!zf) goto L_4f6795;  /* 0x4f66e1: jne 0x4f6795 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4f66e7: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x16eu), 0x0u);  /* 0x4f66ea: mov dword ptr [eax + 0x16e], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4f66f4: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x172u), 0x0u);  /* 0x4f66f7: mov dword ptr [ecx + 0x172], 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4f6701: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(edx + 0x19eu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4f6704: cmp dword ptr [edx + 0x19e], 0 */
    if (zf) goto L_4f6749;  /* 0x4f670b: je 0x4f6749 */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x63a4cdu)))) & 0xffffffffu;  /* 0x4f670d: movsx eax, word ptr [0x63a4cd] */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4f6714: test eax, eax */
    if (zf) goto L_4f6742;  /* 0x4f6716: je 0x4f6742 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4f6718: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4f671b: add ecx, 4 */
    esp -= 4u; WR32(esp, ecx);  /* 0x4f671e: push ecx */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4f671f: mov edx, dword ptr [ebp + 8] */
    esp -= 4u; WR32(esp, edx);  /* 0x4f6722: push edx */
    esp -= 4u; WR32(esp, 0x55e858u);  /* 0x4f6723: push 0x55e858 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4f6728: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4f6732u); FL41_CALL(0x50ca3eu); esp += 4u;  /* 0x4f672d: call 0x50ca3e */
    { uint32_t a_ = esp, b_ = 0x10u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4f6732: add esp, 0x10 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4f6735: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4f673fu); FL41_CALL(0x44a2b7u); esp += 4u;  /* 0x4f673a: call 0x44a2b7 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4f673f: add esp, 4 */
L_4f6742:
    eax = 0x1u;  /* 0x4f6742: mov eax, 1 */
    goto L_4f67b8;  /* 0x4f6747: jmp 0x4f67b8 */
L_4f6749:
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4f6749: mov eax, dword ptr [ebp + 8] */
    esp -= 4u; WR32(esp, eax);  /* 0x4f674c: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4f674d: mov ecx, dword ptr [ebp - 8] */
    esp -= 4u; WR32(esp, 0x4f6755u); FL41_CALL(0x4f6059u); esp += 4u; esp += 4u;  /* 0x4f6750: call 0x4f6059 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4f6755: test eax, eax */
    if (zf) goto L_4f6795;  /* 0x4f6757: je 0x4f6795 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x63a4cdu)))) & 0xffffffffu;  /* 0x4f6759: movsx ecx, word ptr [0x63a4cd] */
    { uint32_t a_ = ecx, b_ = ecx, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4f6760: test ecx, ecx */
    if (zf) goto L_4f678e;  /* 0x4f6762: je 0x4f678e */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4f6764: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4f6767: add edx, 4 */
    esp -= 4u; WR32(esp, edx);  /* 0x4f676a: push edx */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4f676b: mov eax, dword ptr [ebp + 8] */
    esp -= 4u; WR32(esp, eax);  /* 0x4f676e: push eax */
    esp -= 4u; WR32(esp, 0x55e89cu);  /* 0x4f676f: push 0x55e89c */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4f6774: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4f677eu); FL41_CALL(0x50ca3eu); esp += 4u;  /* 0x4f6779: call 0x50ca3e */
    { uint32_t a_ = esp, b_ = 0x10u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4f677e: add esp, 0x10 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4f6781: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4f678bu); FL41_CALL(0x44a2b7u); esp += 4u;  /* 0x4f6786: call 0x44a2b7 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4f678b: add esp, 4 */
L_4f678e:
    eax = 0x1u;  /* 0x4f678e: mov eax, 1 */
    goto L_4f67b8;  /* 0x4f6793: jmp 0x4f67b8 */
L_4f6795:
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4f6795: mov ecx, dword ptr [ebp - 8] */
    WR32((uint32_t)(ecx + 0x3c2u), 0x40du);  /* 0x4f6798: mov dword ptr [ecx + 0x3c2], 0x40d */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4f67a2: mov edx, dword ptr [ebp - 8] */
    WR32((uint32_t)(edx + 0x3beu), 0x0u);  /* 0x4f67a5: mov dword ptr [edx + 0x3be], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4f67af: mov eax, dword ptr [ebp - 8] */
    eax = RD32((uint32_t)(eax + 0x3beu));  /* 0x4f67b2: mov eax, dword ptr [eax + 0x3be] */
L_4f67b8:
    esp = ebp;  /* 0x4f67b8: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4f67ba: pop ebp */
    esp += 12u; goto done;  /* 0x4f67bb: ret 8 */
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

/* GAME.EXE 0x4fafc7 (81 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4fafc7_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4fafc7: push ebp */
    ebp = esp;  /* 0x4fafc8: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x8u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4fafca: sub esp, 8 */
    WR32((uint32_t)(ebp + 0xfffffff8u), ecx);  /* 0x4fafcd: mov dword ptr [ebp - 8], ecx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x63a4cdu)))) & 0xffffffffu;  /* 0x4fafd0: movsx eax, word ptr [0x63a4cd] */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4fafd7: test eax, eax */
    if (zf) goto L_4fafe8;  /* 0x4fafd9: je 0x4fafe8 */
    esp -= 4u; WR32(esp, 0x560648u);  /* 0x4fafdb: push 0x560648 */
    esp -= 4u; WR32(esp, 0x4fafe5u); FL41_CALL(0x44a2b7u); esp += 4u;  /* 0x4fafe0: call 0x44a2b7 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4fafe5: add esp, 4 */
L_4fafe8:
    WR16((uint32_t)(ebp + 0xfffffffcu), 0x0u);  /* 0x4fafe8: mov word ptr [ebp - 4], 0 */
    goto L_4faffc;  /* 0x4fafee: jmp 0x4faffc */
L_4faff0:
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffffcu))) & 0xffffu);  /* 0x4faff0: mov cx, word ptr [ebp - 4] */
    { uint32_t a_ = (ecx & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); ecx = (ecx & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4faff4: add cx, 1 */
    WR16((uint32_t)(ebp + 0xfffffffcu), (ecx & 0xffffu));  /* 0x4faff8: mov word ptr [ebp - 4], cx */
L_4faffc:
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4faffc: movsx edx, word ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0xeu, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4fb000: cmp edx, 0xe */
    if ((sf == of)) goto L_4fb014;  /* 0x4fb003: jge 0x4fb014 */
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffffcu))) & 0xffffu);  /* 0x4fb005: mov ax, word ptr [ebp - 4] */
    esp -= 4u; WR32(esp, eax);  /* 0x4fb009: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4fb00a: mov ecx, dword ptr [ebp - 8] */
    esp -= 4u; WR32(esp, 0x4fb012u); FL41_CALL(0x4fb1c6u); esp += 4u; esp += 4u;  /* 0x4fb00d: call 0x4fb1c6 */
    goto L_4faff0;  /* 0x4fb012: jmp 0x4faff0 */
L_4fb014:
    esp = ebp;  /* 0x4fb014: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4fb016: pop ebp */
    esp += 4u; goto done;  /* 0x4fb017: ret  */
done:
    FL41_EPILOGUE
}

