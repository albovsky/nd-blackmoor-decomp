# FUN_00519561
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519561
# extent:       0x00519561-0x005197de (637 code bytes)
# span:         0x00519561-0x005197de (code 637, tables 0, padding 0)
# sha256:       13a86ebfcaa1dd40bd9b6e4d9f38c0192aecfaa2ba844a97b648e494a5afd40d
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519561
# arguments:    7 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       10 ebp-relative slot(s): local_4, local_10, local_18, local_1c, local_20, local_24, local_28, local_36, local_3c, local_4c
# fields:       [eax + n] field_1
# callees:      calls KERNEL32.dll!CompareStringW, KERNEL32.dll!CompareStringA, FUN_00512bc4, KERNEL32.dll!GetCPInfo, KERNEL32.dll!MultiByteToWideChar, FUN_0050c920; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 239 instruction(s), 34 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         unreachable_code_entry:0x00519718
# note:         unreachable_code_entry:0x00519787
# note:         unreachable_code_entry:0x0051971c
# note:         unreachable_code_entry:0x0051978b
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_10, 0x10  # offset -0x10
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_36, 0x36  # offset -0x36
.equ local_3c, 0x3c  # offset -0x3c
.equ local_4c, 0x4c  # offset -0x4c
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_00512bc4, .text + (0x00512bc4 - 0x401000)

.org 0x00519561 - 0x401000
.globl FUN_00519561
FUN_00519561:
    # block 0x00519561: entry, 18 instruction(s), ends with jne to 0x005195d4 (forward)
    push ebp                                     # 00519561
    {load} mov ebp, esp                          # 00519562
    push -0x1                                    # 00519564
    push 0x5309d8                                # 00519566
    push 0x511930                                # 0051956b
    mov eax, dword ptr fs:[0x0]                  # 00519570
    push eax                                     # 00519576
    mov dword ptr fs:[0x0], esp                  # 00519577
    sub esp, 0x30                                # 0051957e
    push ebx                                     # 00519581
    push esi                                     # 00519582
    push edi                                     # 00519583
    mov dword ptr [ebp - local_18], esp          # 00519584
    {load} xor ebx, ebx                          # 00519587
    cmp dword ptr [0x63cdb8], ebx                # 00519589
    push 0x1                                     # 0051958f
    pop edi                                      # 00519591
    jne.d8 L_005195d4                            # 00519592
    # block 0x00519594: entered by fall-through of jne at 0x00519592, 10 instruction(s), calls KERNEL32.dll!CompareStringW, ends with je to 0x005195b1 (forward)
    push edi                                     # 00519594
    mov eax, 0x5304f4                            # 00519595
    push eax                                     # 0051959a
    push edi                                     # 0051959b
    push eax                                     # 0051959c
    push ebx                                     # 0051959d
    push ebx                                     # 0051959e
    call dword ptr [0x52a1c4]                    # 0051959f
    test eax, eax                                # 005195a5
    je.d8 L_005195b1                             # 005195a7
    # block 0x005195a9: entered by fall-through of je at 0x005195a7, 2 instruction(s), ends with forward jump to 0x005195d4
    mov dword ptr [0x63cdb8], edi                # 005195a9
    jmp.d8 L_005195d4                            # 005195af
L_005195b1:
    # block 0x005195b1: entered by je at 0x005195a7, 10 instruction(s), calls KERNEL32.dll!CompareStringA, ends with je to 0x005197ca (forward)
    push edi                                     # 005195b1
    mov eax, 0x5304f0                            # 005195b2
    push eax                                     # 005195b7
    push edi                                     # 005195b8
    push eax                                     # 005195b9
    push ebx                                     # 005195ba
    push ebx                                     # 005195bb
    call dword ptr [0x52a1c0]                    # 005195bc
    test eax, eax                                # 005195c2
    je.d32 L_005197ca                            # 005195c4
    # block 0x005195ca: entered by fall-through of je at 0x005195c4, 1 instruction(s), falls into the block at 0x005195d4
    mov dword ptr [0x63cdb8], 0x2                # 005195ca
L_005195d4:
    # block 0x005195d4: entered by jne at 0x00519592; jmp at 0x005195af, 3 instruction(s), ends with jle to 0x005195eb (forward)
    mov esi, dword ptr [ebp + arg_14]            # 005195d4
    {load} cmp esi, ebx                          # 005195d7
    jle.d8 L_005195eb                            # 005195d9
    # block 0x005195db: entered by fall-through of jle at 0x005195d9, 7 instruction(s), calls FUN_00512bc4, falls into the block at 0x005195eb
    push esi                                     # 005195db
    push dword ptr [ebp + arg_10]                # 005195dc
    call FUN_00512bc4                            # 005195df
    pop ecx                                      # 005195e4
    pop ecx                                      # 005195e5
    {load} mov esi, eax                          # 005195e6
    mov dword ptr [ebp + arg_14], esi            # 005195e8
L_005195eb:
    # block 0x005195eb: entered by jle at 0x005195d9, 2 instruction(s), ends with jle to 0x00519600 (forward)
    cmp dword ptr [ebp + arg_1c], ebx            # 005195eb
    jle.d8 L_00519600                            # 005195ee
    # block 0x005195f0: entered by fall-through of jle at 0x005195ee, 6 instruction(s), calls FUN_00512bc4, falls into the block at 0x00519600
    push dword ptr [ebp + arg_1c]                # 005195f0
    push dword ptr [ebp + arg_18]                # 005195f3
    call FUN_00512bc4                            # 005195f6
    pop ecx                                      # 005195fb
    pop ecx                                      # 005195fc
    mov dword ptr [ebp + arg_1c], eax            # 005195fd
L_00519600:
    # block 0x00519600: entered by jle at 0x005195ee, 3 instruction(s), ends with jne to 0x00519625 (forward)
    mov eax, dword ptr [0x63cdb8]                # 00519600
    cmp eax, 0x2                                 # 00519605
    jne.d8 L_00519625                            # 00519608
    # block 0x0051960a: entered by fall-through of jne at 0x00519608, 8 instruction(s), calls KERNEL32.dll!CompareStringA, ends with forward jump to 0x005197cc
    push dword ptr [ebp + arg_1c]                # 0051960a
    push dword ptr [ebp + arg_18]                # 0051960d
    push esi                                     # 00519610
    push dword ptr [ebp + arg_10]                # 00519611
    push dword ptr [ebp + arg_c]                 # 00519614
    push dword ptr [ebp + arg_8]                 # 00519617
    call dword ptr [0x52a1c0]                    # 0051961a
    jmp.d32 L_005197cc                           # 00519620
L_00519625:
    # block 0x00519625: entered by jne at 0x00519608, 2 instruction(s), ends with jne to 0x005197ca (forward)
    {load} cmp eax, edi                          # 00519625
    jne.d32 L_005197ca                           # 00519627
    # block 0x0051962d: entered by fall-through of jne at 0x00519627, 2 instruction(s), ends with jne to 0x0051963a (forward)
    cmp dword ptr [ebp + arg_20], ebx            # 0051962d
    jne.d8 L_0051963a                            # 00519630
    # block 0x00519632: entered by fall-through of jne at 0x00519630, 2 instruction(s), falls into the block at 0x0051963a
    mov eax, dword ptr [0x63cb2c]                # 00519632
    mov dword ptr [ebp + arg_20], eax            # 00519637
L_0051963a:
    # block 0x0051963a: entered by jne at 0x00519630, 2 instruction(s), ends with je to 0x00519647 (forward)
    {load} cmp esi, ebx                          # 0051963a
    je.d8 L_00519647                             # 0051963c
    # block 0x0051963e: entered by fall-through of je at 0x0051963c, 2 instruction(s), ends with jne to 0x005196df (forward)
    cmp dword ptr [ebp + arg_1c], ebx            # 0051963e
    jne.d32 L_005196df                           # 00519641
L_00519647:
    # block 0x00519647: entered by je at 0x0051963c; fall-through of jne at 0x00519641, 2 instruction(s), ends with jne to 0x00519654 (forward)
    cmp esi, dword ptr [ebp + arg_1c]            # 00519647
    jne.d8 L_00519654                            # 0051964a
L_0051964c:
    # block 0x0051964c: entered by jbe at 0x0051969d; jbe at 0x005196ce; fall-through of jne at 0x0051964a, 1 instruction(s), falls into the block at 0x0051964e
    push 0x2                                     # 0051964c
L_0051964e:
    # block 0x0051964e: entered by jmp at 0x005196a7, 2 instruction(s), ends with forward jump to 0x005197cc
    pop eax                                      # 0051964e
    jmp.d32 L_005197cc                           # 0051964f
L_00519654:
    # block 0x00519654: entered by jne at 0x0051964a, 2 instruction(s), ends with jle to 0x00519660 (forward)
    cmp dword ptr [ebp + arg_1c], edi            # 00519654
    jle.d8 L_00519660                            # 00519657
L_00519659:
    # block 0x00519659: entered by jb at 0x005196b2; je at 0x005196ba; je at 0x005196c1; jmp at 0x005196da; more, 2 instruction(s), ends with forward jump to 0x005197cc
    {load} mov eax, edi                          # 00519659
    jmp.d32 L_005197cc                           # 0051965b
L_00519660:
    # block 0x00519660: entered by jle at 0x00519657, 2 instruction(s), ends with jg to 0x005196a5 (forward)
    {load} cmp esi, edi                          # 00519660
    jg.d8 L_005196a5                             # 00519662
    # block 0x00519664: entered by fall-through of jg at 0x00519662, 6 instruction(s), calls KERNEL32.dll!GetCPInfo, ends with je to 0x005197ca (forward)
    lea eax, [ebp - local_3c]                    # 00519664
    push eax                                     # 00519667
    push dword ptr [ebp + arg_20]                # 00519668
    call dword ptr [0x52a0e8]                    # 0051966b
    test eax, eax                                # 00519671
    je.d32 L_005197ca                            # 00519673
    # block 0x00519679: entered by fall-through of je at 0x00519673, 2 instruction(s), ends with jle to 0x005196a9 (forward)
    {load} cmp esi, ebx                          # 00519679
    jle.d8 L_005196a9                            # 0051967b
    # block 0x0051967d: entered by fall-through of jle at 0x0051967b, 2 instruction(s), ends with jb to 0x005196a5 (forward)
    cmp dword ptr [ebp - local_3c], 0x2          # 0051967d
    jb.d8 L_005196a5                             # 00519681
    # block 0x00519683: entered by fall-through of jb at 0x00519681, 3 instruction(s), ends with je to 0x005196a5 (forward)
    lea eax, [ebp - local_36]                    # 00519683
    cmp byte ptr [ebp - local_36], bl            # 00519686
    je.d8 L_005196a5                             # 00519689
L_0051968b:
    # block 0x0051968b: entered by jne at 0x005196a3; fall-through of je at 0x00519689, 3 instruction(s), ends with je to 0x005196a5 (forward)
    mov dl, byte ptr [eax + field_1]             # 0051968b
    {load} cmp dl, bl                            # 0051968e
    je.d8 L_005196a5                             # 00519690
    # block 0x00519692: entered by fall-through of je at 0x00519690, 4 instruction(s), ends with jb to 0x0051969f (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 00519692
    mov cl, byte ptr [ecx]                       # 00519695
    cmp cl, byte ptr [eax]                       # 00519697
    jb.d8 L_0051969f                             # 00519699
    # block 0x0051969b: entered by fall-through of jb at 0x00519699, 2 instruction(s), ends with jbe to 0x0051964c (backward)
    {load} cmp cl, dl                            # 0051969b
    jbe.d8 L_0051964c                            # 0051969d
L_0051969f:
    # block 0x0051969f: entered by jb at 0x00519699; fall-through of jbe at 0x0051969d, 4 instruction(s), ends with jne to 0x0051968b (backward)
    inc eax                                      # 0051969f
    inc eax                                      # 005196a0
    cmp byte ptr [eax], bl                       # 005196a1
    jne.d8 L_0051968b                            # 005196a3
L_005196a5:
    # block 0x005196a5: entered by jg at 0x00519662; jb at 0x00519681; je at 0x00519689; je at 0x00519690; more, 2 instruction(s), ends with backward jump to 0x0051964e
    push 0x3                                     # 005196a5
    jmp.d8 L_0051964e                            # 005196a7
L_005196a9:
    # block 0x005196a9: entered by jle at 0x0051967b, 2 instruction(s), ends with jle to 0x005196df (forward)
    cmp dword ptr [ebp + arg_1c], ebx            # 005196a9
    jle.d8 L_005196df                            # 005196ac
    # block 0x005196ae: entered by fall-through of jle at 0x005196ac, 2 instruction(s), ends with jb to 0x00519659 (backward)
    cmp dword ptr [ebp - local_3c], 0x2          # 005196ae
    jb.d8 L_00519659                             # 005196b2
    # block 0x005196b4: entered by fall-through of jb at 0x005196b2, 3 instruction(s), ends with je to 0x00519659 (backward)
    lea eax, [ebp - local_36]                    # 005196b4
    cmp byte ptr [ebp - local_36], bl            # 005196b7
    je.d8 L_00519659                             # 005196ba
L_005196bc:
    # block 0x005196bc: entered by jne at 0x005196d8; fall-through of je at 0x005196ba, 3 instruction(s), ends with je to 0x00519659 (backward)
    mov dl, byte ptr [eax + field_1]             # 005196bc
    {load} cmp dl, bl                            # 005196bf
    je.d8 L_00519659                             # 005196c1
    # block 0x005196c3: entered by fall-through of je at 0x005196c1, 4 instruction(s), ends with jb to 0x005196d4 (forward)
    mov ecx, dword ptr [ebp + arg_18]            # 005196c3
    mov cl, byte ptr [ecx]                       # 005196c6
    cmp cl, byte ptr [eax]                       # 005196c8
    jb.d8 L_005196d4                             # 005196ca
    # block 0x005196cc: entered by fall-through of jb at 0x005196ca, 2 instruction(s), ends with jbe to 0x0051964c (backward)
    {load} cmp cl, dl                            # 005196cc
    jbe.d32 L_0051964c                           # 005196ce
L_005196d4:
    # block 0x005196d4: entered by jb at 0x005196ca; fall-through of jbe at 0x005196ce, 4 instruction(s), ends with jne to 0x005196bc (backward)
    inc eax                                      # 005196d4
    inc eax                                      # 005196d5
    cmp byte ptr [eax], bl                       # 005196d6
    jne.d8 L_005196bc                            # 005196d8
    # block 0x005196da: entered by fall-through of jne at 0x005196d8, 1 instruction(s), ends with backward jump to 0x00519659
    jmp.d32 L_00519659                           # 005196da
L_005196df:
    # block 0x005196df: entered by jne at 0x00519641; jle at 0x005196ac, 10 instruction(s), calls KERNEL32.dll!MultiByteToWideChar, ends with je to 0x005197ca (forward)
    push ebx                                     # 005196df
    push ebx                                     # 005196e0
    push esi                                     # 005196e1
    push dword ptr [ebp + arg_10]                # 005196e2
    push 0x9                                     # 005196e5
    push dword ptr [ebp + arg_20]                # 005196e7
    call dword ptr [0x52a1f0]                    # 005196ea
    mov dword ptr [ebp - local_1c], eax          # 005196f0
    {load} cmp eax, ebx                          # 005196f3
    je.d32 L_005197ca                            # 005196f5
    # block 0x005196fb: entered by fall-through of je at 0x005196f5, 10 instruction(s), calls FUN_0050c920, ends with forward jump to 0x0051972e
    mov dword ptr [ebp - local_4], ebx           # 005196fb
    {load} add eax, eax                          # 005196fe
    add eax, 0x3                                 # 00519700
    and al, -0x4                                 # 00519703
    call FUN_0050c920                            # 00519705
    mov dword ptr [ebp - local_18], esp          # 0051970a
    {load} mov eax, esp                          # 0051970d
    mov dword ptr [ebp - local_24], eax          # 0051970f
    or dword ptr [ebp - local_4], -0x1           # 00519712
    jmp.d8 L_0051972e                            # 00519716
    # block 0x00519718: entered by follows jmp at 0x00519716, 3 instruction(s), ends with ret
    push 0x1                                     # 00519718
    pop eax                                      # 0051971a
    ret                                          # 0051971b
    # block 0x0051971c: entered by follows ret at 0x0051971b, 7 instruction(s), falls into the block at 0x0051972e
    mov esp, dword ptr [ebp - local_18]          # 0051971c
    {load} xor ebx, ebx                          # 0051971f
    mov dword ptr [ebp - local_24], ebx          # 00519721
    or dword ptr [ebp - local_4], -0x1           # 00519724
    mov esi, dword ptr [ebp + arg_14]            # 00519728
    push 0x1                                     # 0051972b
    pop edi                                      # 0051972d
L_0051972e:
    # block 0x0051972e: entered by jmp at 0x00519716, 2 instruction(s), ends with je to 0x005197ca (forward)
    cmp dword ptr [ebp - local_24], ebx          # 0051972e
    je.d32 L_005197ca                            # 00519731
    # block 0x00519737: entered by fall-through of je at 0x00519731, 10 instruction(s), calls indirect esi, ends with je to 0x005197ca (forward)
    push dword ptr [ebp - local_1c]              # 00519737
    push dword ptr [ebp - local_24]              # 0051973a
    push esi                                     # 0051973d
    push dword ptr [ebp + arg_10]                # 0051973e
    push edi                                     # 00519741
    push dword ptr [ebp + arg_20]                # 00519742
    mov esi, dword ptr [0x52a1f0]                # 00519745
    call esi                                     # 0051974b
    test eax, eax                                # 0051974d
    je.d8 L_005197ca                             # 0051974f
    # block 0x00519751: entered by fall-through of je at 0x0051974f, 11 instruction(s), calls indirect esi, ends with je to 0x005197ca (forward)
    push ebx                                     # 00519751
    push ebx                                     # 00519752
    push dword ptr [ebp + arg_1c]                # 00519753
    push dword ptr [ebp + arg_18]                # 00519756
    push 0x9                                     # 00519759
    push dword ptr [ebp + arg_20]                # 0051975b
    call esi                                     # 0051975e
    {load} mov esi, eax                          # 00519760
    mov dword ptr [ebp - local_20], esi          # 00519762
    {load} cmp esi, ebx                          # 00519765
    je.d8 L_005197ca                             # 00519767
    # block 0x00519769: entered by fall-through of je at 0x00519767, 10 instruction(s), calls FUN_0050c920, ends with forward jump to 0x00519799
    mov dword ptr [ebp - local_4], edi           # 00519769
    lea eax, [esi + esi]                         # 0051976c
    add eax, 0x3                                 # 0051976f
    and al, -0x4                                 # 00519772
    call FUN_0050c920                            # 00519774
    mov dword ptr [ebp - local_18], esp          # 00519779
    {load} mov edi, esp                          # 0051977c
    mov dword ptr [ebp - local_28], edi          # 0051977e
    or dword ptr [ebp - local_4], -0x1           # 00519781
    jmp.d8 L_00519799                            # 00519785
    # block 0x00519787: entered by follows jmp at 0x00519785, 3 instruction(s), ends with ret
    push 0x1                                     # 00519787
    pop eax                                      # 00519789
    ret                                          # 0051978a
    # block 0x0051978b: entered by follows ret at 0x0051978a, 5 instruction(s), falls into the block at 0x00519799
    mov esp, dword ptr [ebp - local_18]          # 0051978b
    {load} xor ebx, ebx                          # 0051978e
    {load} xor edi, edi                          # 00519790
    or dword ptr [ebp - local_4], -0x1           # 00519792
    mov esi, dword ptr [ebp - local_20]          # 00519796
L_00519799:
    # block 0x00519799: entered by jmp at 0x00519785, 2 instruction(s), ends with je to 0x005197ca (forward)
    {load} cmp edi, ebx                          # 00519799
    je.d8 L_005197ca                             # 0051979b
    # block 0x0051979d: entered by fall-through of je at 0x0051979b, 9 instruction(s), calls KERNEL32.dll!MultiByteToWideChar, ends with je to 0x005197ca (forward)
    push esi                                     # 0051979d
    push edi                                     # 0051979e
    push dword ptr [ebp + arg_1c]                # 0051979f
    push dword ptr [ebp + arg_18]                # 005197a2
    push 0x1                                     # 005197a5
    push dword ptr [ebp + arg_20]                # 005197a7
    call dword ptr [0x52a1f0]                    # 005197aa
    test eax, eax                                # 005197b0
    je.d8 L_005197ca                             # 005197b2
    # block 0x005197b4: entered by fall-through of je at 0x005197b2, 8 instruction(s), calls KERNEL32.dll!CompareStringW, ends with forward jump to 0x005197cc
    push esi                                     # 005197b4
    push edi                                     # 005197b5
    push dword ptr [ebp - local_1c]              # 005197b6
    push dword ptr [ebp - local_24]              # 005197b9
    push dword ptr [ebp + arg_c]                 # 005197bc
    push dword ptr [ebp + arg_8]                 # 005197bf
    call dword ptr [0x52a1c4]                    # 005197c2
    jmp.d8 L_005197cc                            # 005197c8
L_005197ca:
    # block 0x005197ca: entered by je at 0x005195c4; jne at 0x00519627; je at 0x00519673; je at 0x005196f5; more, 1 instruction(s), falls into the block at 0x005197cc
    {load} xor eax, eax                          # 005197ca
L_005197cc:
    # block 0x005197cc: entered by jmp at 0x00519620; jmp at 0x0051964f; jmp at 0x0051965b; jmp at 0x005197c8, 8 instruction(s), ends with ret
    lea esp, [ebp - local_4c]                    # 005197cc
    mov ecx, dword ptr [ebp - local_10]          # 005197cf
    mov dword ptr fs:[0x0], ecx                  # 005197d2
    pop edi                                      # 005197d9
    pop esi                                      # 005197da
    pop ebx                                      # 005197db
    leave                                        # 005197dc
    ret                                          # 005197dd

