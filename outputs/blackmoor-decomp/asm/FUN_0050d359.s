# FUN_0050d359
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d359
# extent:       0x0050d359-0x0050d4ba (353 code bytes)
# span:         0x0050d359-0x0050d4ba (code 353, tables 0, padding 0)
# sha256:       865b9067d1020b5f293f2cbedddec23220ffac7a8af10aa27ba8be3fc51891a8
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d359
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [ebx + n] field_4; [edi + n] field_4, field_8, field_c, field_d, field_10, field_18; [esi + n] field_4
# callees:      calls FUN_00512178, FUN_0050ea7e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 127 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_d, 0xd  # offset +0xd
.equ field_10, 0x10  # offset +0x10
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)
.set FUN_00512178, .text + (0x00512178 - 0x401000)

.org 0x0050d359 - 0x401000
.globl FUN_0050d359
FUN_0050d359:
    # block 0x0050d359: entry, 12 instruction(s), ends with jge to 0x0050d375 (forward)
    push ebp                                     # 0050d359
    {load} mov ebp, esp                          # 0050d35a
    sub esp, 0xc                                 # 0050d35c
    push ebx                                     # 0050d35f
    push esi                                     # 0050d360
    push edi                                     # 0050d361
    mov edi, dword ptr [ebp + arg_8]             # 0050d362
    {load} xor ebx, ebx                          # 0050d365
    mov esi, dword ptr [edi + field_10]          # 0050d367
    cmp dword ptr [edi + field_4], ebx           # 0050d36a
    mov dword ptr [ebp - local_c], esi           # 0050d36d
    jge.d8 L_0050d375                            # 0050d370
    # block 0x0050d372: entered by fall-through of jge at 0x0050d370, 1 instruction(s), falls into the block at 0x0050d375
    mov dword ptr [edi + field_4], ebx           # 0050d372
L_0050d375:
    # block 0x0050d375: entered by jge at 0x0050d370, 8 instruction(s), calls FUN_00512178, ends with jl to 0x0050d3e7 (forward)
    push 0x1                                     # 0050d375
    push ebx                                     # 0050d377
    push esi                                     # 0050d378
    call FUN_00512178                            # 0050d379
    add esp, 0xc                                 # 0050d37e
    {load} cmp eax, ebx                          # 0050d381
    mov dword ptr [ebp - local_4], eax           # 0050d383
    jl.d8 L_0050d3e7                             # 0050d386
    # block 0x0050d388: entered by fall-through of jl at 0x0050d386, 3 instruction(s), ends with jne to 0x0050d39a (forward)
    mov ecx, dword ptr [edi + field_c]           # 0050d388
    test cx, 0x108                               # 0050d38b
    jne.d8 L_0050d39a                            # 0050d390
    # block 0x0050d392: entered by fall-through of jne at 0x0050d390, 2 instruction(s), ends with forward jump to 0x0050d4b5
    sub eax, dword ptr [edi + field_4]           # 0050d392
    jmp.d32 L_0050d4b5                           # 0050d395
L_0050d39a:
    # block 0x0050d39a: entered by jne at 0x0050d390, 7 instruction(s), ends with je to 0x0050d3d7 (forward)
    mov eax, dword ptr [edi]                     # 0050d39a
    mov edx, dword ptr [edi + field_8]           # 0050d39c
    {load} mov ebx, eax                          # 0050d39f
    {load} sub ebx, edx                          # 0050d3a1
    test cl, 0x3                                 # 0050d3a3
    mov dword ptr [ebp - local_8], ebx           # 0050d3a6
    je.d8 L_0050d3d7                             # 0050d3a9
    # block 0x0050d3ab: entered by fall-through of je at 0x0050d3a9, 8 instruction(s), ends with je to 0x0050d3ef (forward)
    {load} mov ebx, esi                          # 0050d3ab
    {load} mov ecx, esi                          # 0050d3ad
    sar ebx, 0x5                                 # 0050d3af
    and ecx, 0x1f                                # 0050d3b2
    mov ebx, dword ptr [4*ebx + 0x63cde0]        # 0050d3b5
    lea ecx, [ecx + 8*ecx]                       # 0050d3bc
    test byte ptr [ebx + 4*ecx + field_4], -0x80 # 0050d3bf
    je.d8 L_0050d3ef                             # 0050d3c4
    # block 0x0050d3c6: entered by fall-through of je at 0x0050d3c4, 1 instruction(s), falls into the block at 0x0050d3c8
    {load} mov ecx, edx                          # 0050d3c6
L_0050d3c8:
    # block 0x0050d3c8: entered by jmp at 0x0050d3d5, 2 instruction(s), ends with jae to 0x0050d3ef (forward)
    {load} cmp ecx, eax                          # 0050d3c8
    jae.d8 L_0050d3ef                            # 0050d3ca
    # block 0x0050d3cc: entered by fall-through of jae at 0x0050d3ca, 2 instruction(s), ends with jne to 0x0050d3d4 (forward)
    cmp byte ptr [ecx], 0xa                      # 0050d3cc
    jne.d8 L_0050d3d4                            # 0050d3cf
    # block 0x0050d3d1: entered by fall-through of jne at 0x0050d3cf, 1 instruction(s), falls into the block at 0x0050d3d4
    inc dword ptr [ebp - local_8]                # 0050d3d1
L_0050d3d4:
    # block 0x0050d3d4: entered by jne at 0x0050d3cf, 2 instruction(s), ends with backward jump to 0x0050d3c8
    inc ecx                                      # 0050d3d4
    jmp.d8 L_0050d3c8                            # 0050d3d5
L_0050d3d7:
    # block 0x0050d3d7: entered by je at 0x0050d3a9, 2 instruction(s), ends with jne to 0x0050d3ef (forward)
    test cl, -0x80                               # 0050d3d7
    jne.d8 L_0050d3ef                            # 0050d3da
    # block 0x0050d3dc: entered by fall-through of jne at 0x0050d3da, 2 instruction(s), calls FUN_0050ea7e, falls into the block at 0x0050d3e7
    call FUN_0050ea7e                            # 0050d3dc
    mov dword ptr [eax], 0x16                    # 0050d3e1
L_0050d3e7:
    # block 0x0050d3e7: entered by jl at 0x0050d386, 2 instruction(s), ends with forward jump to 0x0050d4b5
    or eax, -0x1                                 # 0050d3e7
    jmp.d32 L_0050d4b5                           # 0050d3ea
L_0050d3ef:
    # block 0x0050d3ef: entered by je at 0x0050d3c4; jae at 0x0050d3ca; jne at 0x0050d3da, 2 instruction(s), ends with jne to 0x0050d3fd (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0050d3ef
    jne.d8 L_0050d3fd                            # 0050d3f3
    # block 0x0050d3f5: entered by fall-through of jne at 0x0050d3f3, 2 instruction(s), ends with forward jump to 0x0050d4b5
    mov eax, dword ptr [ebp - local_8]           # 0050d3f5
    jmp.d32 L_0050d4b5                           # 0050d3f8
L_0050d3fd:
    # block 0x0050d3fd: entered by jne at 0x0050d3f3, 2 instruction(s), ends with je to 0x0050d4ad (forward)
    test byte ptr [edi + field_c], 0x1           # 0050d3fd
    je.d32 L_0050d4ad                            # 0050d401
    # block 0x0050d407: entered by fall-through of je at 0x0050d401, 3 instruction(s), ends with jne to 0x0050d416 (forward)
    mov ecx, dword ptr [edi + field_4]           # 0050d407
    test ecx, ecx                                # 0050d40a
    jne.d8 L_0050d416                            # 0050d40c
    # block 0x0050d40e: entered by fall-through of jne at 0x0050d40c, 2 instruction(s), ends with forward jump to 0x0050d4ad
    and dword ptr [ebp - local_8], ecx           # 0050d40e
    jmp.d32 L_0050d4ad                           # 0050d411
L_0050d416:
    # block 0x0050d416: entered by jne at 0x0050d40c, 13 instruction(s), ends with je to 0x0050d4a7 (forward)
    {load} sub eax, edx                          # 0050d416
    {load} add eax, ecx                          # 0050d418
    mov dword ptr [ebp + arg_8], eax             # 0050d41a
    {load} mov eax, esi                          # 0050d41d
    sar eax, 0x5                                 # 0050d41f
    lea ebx, [4*eax + 0x63cde0]                  # 0050d422
    {load} mov eax, esi                          # 0050d429
    and eax, 0x1f                                # 0050d42b
    lea esi, [eax + 8*eax]                       # 0050d42e
    mov eax, dword ptr [ebx]                     # 0050d431
    shl esi, 0x2                                 # 0050d433
    test byte ptr [esi + eax + field_4], -0x80   # 0050d436
    je.d8 L_0050d4a7                             # 0050d43b
    # block 0x0050d43d: entered by fall-through of je at 0x0050d43b, 7 instruction(s), calls FUN_00512178, ends with jne to 0x0050d46e (forward)
    push 0x2                                     # 0050d43d
    push 0x0                                     # 0050d43f
    push dword ptr [ebp - local_c]               # 0050d441
    call FUN_00512178                            # 0050d444
    add esp, 0xc                                 # 0050d449
    cmp eax, dword ptr [ebp - local_4]           # 0050d44c
    jne.d8 L_0050d46e                            # 0050d44f
    # block 0x0050d451: entered by fall-through of jne at 0x0050d44f, 3 instruction(s), falls into the block at 0x0050d459
    mov eax, dword ptr [edi + field_8]           # 0050d451
    mov ecx, dword ptr [ebp + arg_8]             # 0050d454
    {load} add ecx, eax                          # 0050d457
L_0050d459:
    # block 0x0050d459: entered by jmp at 0x0050d466, 2 instruction(s), ends with jae to 0x0050d468 (forward)
    {load} cmp eax, ecx                          # 0050d459
    jae.d8 L_0050d468                            # 0050d45b
    # block 0x0050d45d: entered by fall-through of jae at 0x0050d45b, 2 instruction(s), ends with jne to 0x0050d465 (forward)
    cmp byte ptr [eax], 0xa                      # 0050d45d
    jne.d8 L_0050d465                            # 0050d460
    # block 0x0050d462: entered by fall-through of jne at 0x0050d460, 1 instruction(s), falls into the block at 0x0050d465
    inc dword ptr [ebp + arg_8]                  # 0050d462
L_0050d465:
    # block 0x0050d465: entered by jne at 0x0050d460, 2 instruction(s), ends with backward jump to 0x0050d459
    inc eax                                      # 0050d465
    jmp.d8 L_0050d459                            # 0050d466
L_0050d468:
    # block 0x0050d468: entered by jae at 0x0050d45b, 2 instruction(s), ends with forward jump to 0x0050d4a2
    test byte ptr [edi + field_d], 0x20          # 0050d468
    jmp.d8 L_0050d4a2                            # 0050d46c
L_0050d46e:
    # block 0x0050d46e: entered by jne at 0x0050d44f, 8 instruction(s), calls FUN_00512178, ends with ja to 0x0050d495 (forward)
    push 0x0                                     # 0050d46e
    push dword ptr [ebp - local_4]               # 0050d470
    push dword ptr [ebp - local_c]               # 0050d473
    call FUN_00512178                            # 0050d476
    mov eax, 0x200                               # 0050d47b
    add esp, 0xc                                 # 0050d480
    cmp dword ptr [ebp + arg_8], eax             # 0050d483
    ja.d8 L_0050d495                             # 0050d486
    # block 0x0050d488: entered by fall-through of ja at 0x0050d486, 3 instruction(s), ends with je to 0x0050d495 (forward)
    mov ecx, dword ptr [edi + field_c]           # 0050d488
    test cl, 0x8                                 # 0050d48b
    je.d8 L_0050d495                             # 0050d48e
    # block 0x0050d490: entered by fall-through of je at 0x0050d48e, 2 instruction(s), ends with je to 0x0050d498 (forward)
    test ch, 0x4                                 # 0050d490
    je.d8 L_0050d498                             # 0050d493
L_0050d495:
    # block 0x0050d495: entered by ja at 0x0050d486; je at 0x0050d48e; fall-through of je at 0x0050d493, 1 instruction(s), falls into the block at 0x0050d498
    mov eax, dword ptr [edi + field_18]          # 0050d495
L_0050d498:
    # block 0x0050d498: entered by je at 0x0050d493, 3 instruction(s), falls into the block at 0x0050d4a2
    mov dword ptr [ebp + arg_8], eax             # 0050d498
    mov eax, dword ptr [ebx]                     # 0050d49b
    test byte ptr [esi + eax + field_4], 0x4     # 0050d49d
L_0050d4a2:
    # block 0x0050d4a2: entered by jmp at 0x0050d46c, 1 instruction(s), ends with je to 0x0050d4a7 (forward)
    je.d8 L_0050d4a7                             # 0050d4a2
    # block 0x0050d4a4: entered by fall-through of je at 0x0050d4a2, 1 instruction(s), falls into the block at 0x0050d4a7
    inc dword ptr [ebp + arg_8]                  # 0050d4a4
L_0050d4a7:
    # block 0x0050d4a7: entered by je at 0x0050d43b; je at 0x0050d4a2, 2 instruction(s), falls into the block at 0x0050d4ad
    mov eax, dword ptr [ebp + arg_8]             # 0050d4a7
    sub dword ptr [ebp - local_4], eax           # 0050d4aa
L_0050d4ad:
    # block 0x0050d4ad: entered by je at 0x0050d401; jmp at 0x0050d411, 3 instruction(s), falls into the block at 0x0050d4b5
    mov eax, dword ptr [ebp - local_8]           # 0050d4ad
    mov ecx, dword ptr [ebp - local_4]           # 0050d4b0
    {load} add eax, ecx                          # 0050d4b3
L_0050d4b5:
    # block 0x0050d4b5: entered by jmp at 0x0050d395; jmp at 0x0050d3ea; jmp at 0x0050d3f8, 5 instruction(s), ends with ret
    pop edi                                      # 0050d4b5
    pop esi                                      # 0050d4b6
    pop ebx                                      # 0050d4b7
    leave                                        # 0050d4b8
    ret                                          # 0050d4b9

