# FUN_0051c2ab
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c2ab
# extent:       0x0051c2ab-0x0051c3e5 (314 code bytes)
# span:         0x0051c2ab-0x0051c3e5 (code 314, tables 0, padding 0)
# sha256:       2f3fc65da4b9d9256396dae2b8018862f0e31b5472a1e5f81e48b7474fc039ce
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c2ab
# arguments:    7 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20; ret 0x1c (callee pops 28 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       9 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24
# fields:       [eax + n] field_4, field_8, field_c; [ebx + n] field_1c; [edx + n] field_4, field_8, field_c, field_60
# callees:      calls USER32.dll!GetClientRect, USER32.dll!BeginDeferWindowPos, USER32.dll!GetTopWindow, USER32.dll!GetDlgCtrlID, FUN_0051ac0b, USER32.dll!SendMessageA, USER32.dll!GetWindow, USER32.dll!CopyRect, FUN_0051abe4, FUN_0051c3e5, USER32.dll!EndDeferWindowPos; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 120 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ field_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ field_60, 0x60  # offset +0x60

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_0051ac0b, .text + (0x0051ac0b - 0x401000)
.set FUN_0051c3e5, .text + (0x0051c3e5 - 0x401000)

.org 0x0051c2ab - 0x401000
.globl FUN_0051c2ab
FUN_0051c2ab:
    # block 0x0051c2ab: entry, 16 instruction(s), ends with je to 0x0051c2d7 (forward)
    push ebp                                     # 0051c2ab
    {load} mov ebp, esp                          # 0051c2ac
    sub esp, 0x24                                # 0051c2ae
    push ebx                                     # 0051c2b1
    push esi                                     # 0051c2b2
    mov esi, dword ptr [ebp + arg_1c]            # 0051c2b3
    {load} mov ebx, ecx                          # 0051c2b6
    mov ecx, dword ptr [ebp + arg_20]            # 0051c2b8
    {load} xor eax, eax                          # 0051c2bb
    {load} cmp esi, eax                          # 0051c2bd
    push edi                                     # 0051c2bf
    mov dword ptr [ebp - local_4], eax           # 0051c2c0
    mov dword ptr [ebp - local_8], ecx           # 0051c2c3
    mov dword ptr [ebp - local_c], eax           # 0051c2c6
    mov dword ptr [ebp - local_10], eax          # 0051c2c9
    je.d8 L_0051c2d7                             # 0051c2cc
    # block 0x0051c2ce: entered by fall-through of je at 0x0051c2cc, 6 instruction(s), ends with forward jump to 0x0051c2e4
    lea edi, [ebp - local_20]                    # 0051c2ce
    movsd dword ptr es:[edi], dword ptr [esi]    # 0051c2d1
    movsd dword ptr es:[edi], dword ptr [esi]    # 0051c2d2
    movsd dword ptr es:[edi], dword ptr [esi]    # 0051c2d3
    movsd dword ptr es:[edi], dword ptr [esi]    # 0051c2d4
    jmp.d8 L_0051c2e4                            # 0051c2d5
L_0051c2d7:
    # block 0x0051c2d7: entered by je at 0x0051c2cc, 4 instruction(s), calls USER32.dll!GetClientRect, falls into the block at 0x0051c2e4
    lea eax, [ebp - local_20]                    # 0051c2d7
    push eax                                     # 0051c2da
    push dword ptr [ebx + field_1c]              # 0051c2db
    call dword ptr [0x52a4d8]                    # 0051c2de
L_0051c2e4:
    # block 0x0051c2e4: entered by jmp at 0x0051c2d5, 2 instruction(s), ends with je to 0x0051c2f7 (forward)
    cmp dword ptr [ebp + arg_14], 0x1            # 0051c2e4
    je.d8 L_0051c2f7                             # 0051c2e8
    # block 0x0051c2ea: entered by fall-through of je at 0x0051c2e8, 4 instruction(s), calls USER32.dll!BeginDeferWindowPos, ends with forward jump to 0x0051c2fb
    push 0x8                                     # 0051c2ea
    call dword ptr [0x52a2f0]                    # 0051c2ec
    mov dword ptr [ebp - local_24], eax          # 0051c2f2
    jmp.d8 L_0051c2fb                            # 0051c2f5
L_0051c2f7:
    # block 0x0051c2f7: entered by je at 0x0051c2e8, 1 instruction(s), falls into the block at 0x0051c2fb
    and dword ptr [ebp - local_24], 0x0          # 0051c2f7
L_0051c2fb:
    # block 0x0051c2fb: entered by jmp at 0x0051c2f5, 4 instruction(s), calls USER32.dll!GetTopWindow, falls into the block at 0x0051c308
    push dword ptr [ebx + field_1c]              # 0051c2fb
    call dword ptr [0x52a3d4]                    # 0051c2fe
    {load} mov esi, eax                          # 0051c304
    {load} xor ebx, ebx                          # 0051c306
L_0051c308:
    # block 0x0051c308: entered by jmp at 0x0051c350, 2 instruction(s), ends with je to 0x0051c352 (forward)
    {load} cmp esi, ebx                          # 0051c308
    je.d8 L_0051c352                             # 0051c30a
    # block 0x0051c30c: entered by fall-through of je at 0x0051c30a, 7 instruction(s), calls USER32.dll!GetDlgCtrlID, FUN_0051ac0b, ends with jne to 0x0051c326 (forward)
    push esi                                     # 0051c30c
    call dword ptr [0x52a40c]                    # 0051c30d
    push esi                                     # 0051c313
    movzx edi, ax                                # 0051c314
    call FUN_0051ac0b                            # 0051c317
    cmp edi, dword ptr [ebp + arg_10]            # 0051c31c
    jne.d8 L_0051c326                            # 0051c31f
    # block 0x0051c321: entered by fall-through of jne at 0x0051c31f, 2 instruction(s), ends with forward jump to 0x0051c345
    mov dword ptr [ebp - local_4], esi           # 0051c321
    jmp.d8 L_0051c345                            # 0051c324
L_0051c326:
    # block 0x0051c326: entered by jne at 0x0051c31f, 2 instruction(s), ends with jb to 0x0051c345 (forward)
    cmp edi, dword ptr [ebp + arg_8]             # 0051c326
    jb.d8 L_0051c345                             # 0051c329
    # block 0x0051c32b: entered by fall-through of jb at 0x0051c329, 2 instruction(s), ends with ja to 0x0051c345 (forward)
    cmp edi, dword ptr [ebp + arg_c]             # 0051c32b
    ja.d8 L_0051c345                             # 0051c32e
    # block 0x0051c330: entered by fall-through of ja at 0x0051c32e, 2 instruction(s), ends with je to 0x0051c345 (forward)
    {load} cmp eax, ebx                          # 0051c330
    je.d8 L_0051c345                             # 0051c332
    # block 0x0051c334: entered by fall-through of je at 0x0051c332, 6 instruction(s), calls USER32.dll!SendMessageA, falls into the block at 0x0051c345
    lea eax, [ebp - local_24]                    # 0051c334
    push eax                                     # 0051c337
    push ebx                                     # 0051c338
    push 0x361                                   # 0051c339
    push esi                                     # 0051c33e
    call dword ptr [0x52a4c8]                    # 0051c33f
L_0051c345:
    # block 0x0051c345: entered by jmp at 0x0051c324; jb at 0x0051c329; ja at 0x0051c32e; je at 0x0051c332, 5 instruction(s), calls USER32.dll!GetWindow, ends with backward jump to 0x0051c308
    push 0x2                                     # 0051c345
    push esi                                     # 0051c347
    call dword ptr [0x52a450]                    # 0051c348
    {load} mov esi, eax                          # 0051c34e
    jmp.d8 L_0051c308                            # 0051c350
L_0051c352:
    # block 0x0051c352: entered by je at 0x0051c30a, 2 instruction(s), ends with jne to 0x0051c382 (forward)
    cmp dword ptr [ebp + arg_14], 0x1            # 0051c352
    jne.d8 L_0051c382                            # 0051c356
    # block 0x0051c358: entered by fall-through of jne at 0x0051c356, 2 instruction(s), ends with je to 0x0051c36c (forward)
    cmp dword ptr [ebp + arg_20], ebx            # 0051c358
    je.d8 L_0051c36c                             # 0051c35b
    # block 0x0051c35d: entered by fall-through of je at 0x0051c35b, 5 instruction(s), calls USER32.dll!CopyRect, ends with forward jump to 0x0051c3de
    lea eax, [ebp - local_20]                    # 0051c35d
    push eax                                     # 0051c360
    push dword ptr [ebp + arg_18]                # 0051c361
    call dword ptr [0x52a4ac]                    # 0051c364
    jmp.d8 L_0051c3de                            # 0051c36a
L_0051c36c:
    # block 0x0051c36c: entered by je at 0x0051c35b, 8 instruction(s), ends with forward jump to 0x0051c3de
    mov eax, dword ptr [ebp + arg_18]            # 0051c36c
    mov ecx, dword ptr [ebp - local_10]          # 0051c36f
    mov dword ptr [eax + field_8], ecx           # 0051c372
    mov ecx, dword ptr [ebp - local_c]           # 0051c375
    mov dword ptr [eax + field_4], ebx           # 0051c378
    mov dword ptr [eax], ebx                     # 0051c37b
    mov dword ptr [eax + field_c], ecx           # 0051c37d
    jmp.d8 L_0051c3de                            # 0051c380
L_0051c382:
    # block 0x0051c382: entered by jne at 0x0051c356, 2 instruction(s), ends with je to 0x0051c3d0 (forward)
    cmp dword ptr [ebp + arg_10], ebx            # 0051c382
    je.d8 L_0051c3d0                             # 0051c385
    # block 0x0051c387: entered by fall-through of je at 0x0051c385, 2 instruction(s), ends with je to 0x0051c3d0 (forward)
    cmp dword ptr [ebp - local_4], ebx           # 0051c387
    je.d8 L_0051c3d0                             # 0051c38a
    # block 0x0051c38c: entered by fall-through of je at 0x0051c38a, 4 instruction(s), calls FUN_0051abe4, ends with jne to 0x0051c3b4 (forward)
    push dword ptr [ebp - local_4]               # 0051c38c
    call FUN_0051abe4                            # 0051c38f
    cmp dword ptr [ebp + arg_14], 0x2            # 0051c394
    jne.d8 L_0051c3b4                            # 0051c398
    # block 0x0051c39a: entered by fall-through of jne at 0x0051c398, 9 instruction(s), falls into the block at 0x0051c3b4
    mov edx, dword ptr [ebp + arg_18]            # 0051c39a
    mov ecx, dword ptr [edx]                     # 0051c39d
    add dword ptr [ebp - local_20], ecx          # 0051c39f
    mov ecx, dword ptr [edx + field_4]           # 0051c3a2
    add dword ptr [ebp - local_1c], ecx          # 0051c3a5
    mov ecx, dword ptr [edx + field_8]           # 0051c3a8
    sub dword ptr [ebp - local_18], ecx          # 0051c3ab
    mov ecx, dword ptr [edx + field_c]           # 0051c3ae
    sub dword ptr [ebp - local_14], ecx          # 0051c3b1
L_0051c3b4:
    # block 0x0051c3b4: entered by jne at 0x0051c398, 12 instruction(s), calls indirect dword ptr [edx + 0x60], FUN_0051c3e5, falls into the block at 0x0051c3d0
    mov edx, dword ptr [eax]                     # 0051c3b4
    lea ecx, [ebp - local_20]                    # 0051c3b6
    push ebx                                     # 0051c3b9
    push ecx                                     # 0051c3ba
    {load} mov ecx, eax                          # 0051c3bb
    call dword ptr [edx + field_60]              # 0051c3bd
    lea eax, [ebp - local_20]                    # 0051c3c0
    push eax                                     # 0051c3c3
    lea eax, [ebp - local_24]                    # 0051c3c4
    push dword ptr [ebp - local_4]               # 0051c3c7
    push eax                                     # 0051c3ca
    call FUN_0051c3e5                            # 0051c3cb
L_0051c3d0:
    # block 0x0051c3d0: entered by je at 0x0051c385; je at 0x0051c38a, 2 instruction(s), ends with je to 0x0051c3de (forward)
    cmp dword ptr [ebp - local_24], ebx          # 0051c3d0
    je.d8 L_0051c3de                             # 0051c3d3
    # block 0x0051c3d5: entered by fall-through of je at 0x0051c3d3, 2 instruction(s), calls USER32.dll!EndDeferWindowPos, falls into the block at 0x0051c3de
    push dword ptr [ebp - local_24]              # 0051c3d5
    call dword ptr [0x52a2ec]                    # 0051c3d8
L_0051c3de:
    # block 0x0051c3de: entered by jmp at 0x0051c36a; jmp at 0x0051c380; je at 0x0051c3d3, 5 instruction(s), ends with ret 0x1c
    pop edi                                      # 0051c3de
    pop esi                                      # 0051c3df
    pop ebx                                      # 0051c3e0
    leave                                        # 0051c3e1
    ret 0x1c                                     # 0051c3e2

