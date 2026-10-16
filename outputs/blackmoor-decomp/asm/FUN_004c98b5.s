# FUN_004c98b5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c98b5
# extent:       0x004c98b5-0x004c9b25 (624 code bytes)
# span:         0x004c98b5-0x004c9b25 (code 624, tables 0, padding 0)
# sha256:       a7c162ceb4edb58d53a83802cc9ecccfd89d452aa34fccaaae7108f93fcd7eb0
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c98b5
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       17 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 5 more
# fields:       [eax + n] field_10, field_46, field_4a, field_24a, field_44a, field_64a, field_84a, field_a4a, field_c62, field_c66, field_e82; [ecx + n] field_46, field_c52, field_c62, field_e82; [edx + n] field_10, field_46, field_c4a, field_c5e, field_e82
# callees:      calls FUN_0050ce04, FUN_004c88c7, FUN_0042639d, FUN_004c97b4; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 186 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
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
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ field_10, 0x10  # offset +0x10
.equ field_46, 0x46  # offset +0x46
.equ field_4a, 0x4a  # offset +0x4a
.equ field_24a, 0x24a  # offset +0x24a
.equ field_44a, 0x44a  # offset +0x44a
.equ field_64a, 0x64a  # offset +0x64a
.equ field_84a, 0x84a  # offset +0x84a
.equ field_a4a, 0xa4a  # offset +0xa4a
.equ field_c4a, 0xc4a  # offset +0xc4a
.equ field_c52, 0xc52  # offset +0xc52
.equ field_c5e, 0xc5e  # offset +0xc5e
.equ field_c62, 0xc62  # offset +0xc62
.equ field_c66, 0xc66  # offset +0xc66
.equ field_e82, 0xe82  # offset +0xe82

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c88c7, .text + (0x004c88c7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004c98b5 - 0x401000
.globl FUN_004c98b5
FUN_004c98b5:
    # block 0x004c98b5: entry, 9 instruction(s), ends with je to 0x004c98e1 (forward)
    push ebp                                     # 004c98b5
    {load} mov ebp, esp                          # 004c98b6
    sub esp, 0x44                                # 004c98b8
    push esi                                     # 004c98bb
    push edi                                     # 004c98bc
    mov dword ptr [ebp - local_1c], ecx          # 004c98bd
    mov eax, dword ptr [ebp - local_1c]          # 004c98c0
    cmp dword ptr [eax + field_c66], 0x0         # 004c98c3
    je.d8 L_004c98e1                             # 004c98ca
    # block 0x004c98cc: entered by fall-through of je at 0x004c98ca, 3 instruction(s), ends with je to 0x004c98e1 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004c98cc
    cmp dword ptr [ecx + field_c52], 0x0         # 004c98cf
    je.d8 L_004c98e1                             # 004c98d6
    # block 0x004c98d8: entered by fall-through of je at 0x004c98d6, 3 instruction(s), ends with jne to 0x004c98e6 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c98d8
    cmp dword ptr [edx + field_46], 0x0          # 004c98db
    jne.d8 L_004c98e6                            # 004c98df
L_004c98e1:
    # block 0x004c98e1: entered by je at 0x004c98ca; je at 0x004c98d6; fall-through of jne at 0x004c98df, 1 instruction(s), ends with forward jump to 0x004c9b1f
    jmp.d32 L_004c9b1f                           # 004c98e1
L_004c98e6:
    # block 0x004c98e6: entered by jne at 0x004c98df, 12 instruction(s), ends with jne to 0x004c9934 (forward)
    mov dword ptr [ebp - local_4], 0xffff        # 004c98e6
    mov eax, dword ptr [ebp - local_1c]          # 004c98ed
    fild dword ptr [eax + field_c62]             # 004c98f0
    fstp dword ptr [ebp - local_20]              # 004c98f6
    fld dword ptr [ebp - local_20]               # 004c98f9
    fdiv dword ptr [0x52cbec]                    # 004c98fc
    fstp dword ptr [ebp - local_10]              # 004c9902
    mov ecx, dword ptr [ebp - local_1c]          # 004c9905
    mov edx, dword ptr [ebp - local_1c]          # 004c9908
    mov eax, dword ptr [ecx + field_c62]         # 004c990b
    cmp eax, dword ptr [edx + field_c5e]         # 004c9911
    jne.d8 L_004c9934                            # 004c9917
    # block 0x004c9919: entered by fall-through of jne at 0x004c9917, 7 instruction(s), ends with forward jump to 0x004c9a84
    mov esi, dword ptr [ebp - local_1c]          # 004c9919
    add esi, 0x4a                                # 004c991c
    mov edi, dword ptr [ebp - local_1c]          # 004c991f
    add edi, 0x64a                               # 004c9922
    mov ecx, 0x180                               # 004c9928
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c992d
    jmp.d32 L_004c9a84                           # 004c992f
L_004c9934:
    # block 0x004c9934: entered by jne at 0x004c9917, 2 instruction(s), ends with forward jump to 0x004c9946
    mov dword ptr [ebp - local_18], 0x0          # 004c9934
    jmp.d8 L_004c9946                            # 004c993b
L_004c993d:
    # block 0x004c993d: entered by jmp at 0x004c9a7f, 3 instruction(s), falls into the block at 0x004c9946
    mov ecx, dword ptr [ebp - local_18]          # 004c993d
    add ecx, 0x1                                 # 004c9940
    mov dword ptr [ebp - local_18], ecx          # 004c9943
L_004c9946:
    # block 0x004c9946: entered by jmp at 0x004c993b, 2 instruction(s), ends with jge to 0x004c9a84 (forward)
    cmp dword ptr [ebp - local_18], 0x100        # 004c9946
    jge.d32 L_004c9a84                           # 004c994d
    # block 0x004c9953: entered by fall-through of jge at 0x004c994d, 36 instruction(s), calls FUN_0050ce04, ends with jge to 0x004c99d5 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004c9953
    mov eax, dword ptr [ebp - local_1c]          # 004c9956
    {load} xor ecx, ecx                          # 004c9959
    mov cx, word ptr [eax + 2*edx + field_4a]    # 004c995b
    mov dword ptr [ebp - local_24], ecx          # 004c9960
    fild dword ptr [ebp - local_24]              # 004c9963
    fstp dword ptr [ebp - local_28]              # 004c9966
    fld dword ptr [ebp - local_28]               # 004c9969
    fmul dword ptr [ebp - local_10]              # 004c996c
    call FUN_0050ce04                            # 004c996f
    mov dword ptr [ebp - local_8], eax           # 004c9974
    mov edx, dword ptr [ebp - local_18]          # 004c9977
    mov eax, dword ptr [ebp - local_1c]          # 004c997a
    {load} xor ecx, ecx                          # 004c997d
    mov cx, word ptr [eax + 2*edx + field_24a]   # 004c997f
    mov dword ptr [ebp - local_2c], ecx          # 004c9987
    fild dword ptr [ebp - local_2c]              # 004c998a
    fstp dword ptr [ebp - local_30]              # 004c998d
    fld dword ptr [ebp - local_30]               # 004c9990
    fmul dword ptr [ebp - local_10]              # 004c9993
    call FUN_0050ce04                            # 004c9996
    mov dword ptr [ebp - local_14], eax          # 004c999b
    mov edx, dword ptr [ebp - local_18]          # 004c999e
    mov eax, dword ptr [ebp - local_1c]          # 004c99a1
    {load} xor ecx, ecx                          # 004c99a4
    mov cx, word ptr [eax + 2*edx + field_44a]   # 004c99a6
    mov dword ptr [ebp - local_34], ecx          # 004c99ae
    fild dword ptr [ebp - local_34]              # 004c99b1
    fstp dword ptr [ebp - local_38]              # 004c99b4
    fld dword ptr [ebp - local_38]               # 004c99b7
    fmul dword ptr [ebp - local_10]              # 004c99ba
    call FUN_0050ce04                            # 004c99bd
    mov dword ptr [ebp - local_c], eax           # 004c99c2
    mov edx, dword ptr [ebp - local_8]           # 004c99c5
    cmp edx, dword ptr [ebp - local_4]           # 004c99c8
    jge.d8 L_004c99d5                            # 004c99cb
    # block 0x004c99cd: entered by fall-through of jge at 0x004c99cb, 3 instruction(s), ends with forward jump to 0x004c99db
    mov eax, dword ptr [ebp - local_8]           # 004c99cd
    mov dword ptr [ebp - local_3c], eax          # 004c99d0
    jmp.d8 L_004c99db                            # 004c99d3
L_004c99d5:
    # block 0x004c99d5: entered by jge at 0x004c99cb, 2 instruction(s), falls into the block at 0x004c99db
    mov ecx, dword ptr [ebp - local_4]           # 004c99d5
    mov dword ptr [ebp - local_3c], ecx          # 004c99d8
L_004c99db:
    # block 0x004c99db: entered by jmp at 0x004c99d3, 5 instruction(s), ends with jge to 0x004c99f1 (forward)
    mov edx, dword ptr [ebp - local_3c]          # 004c99db
    mov dword ptr [ebp - local_8], edx           # 004c99de
    mov eax, dword ptr [ebp - local_14]          # 004c99e1
    cmp eax, dword ptr [ebp - local_4]           # 004c99e4
    jge.d8 L_004c99f1                            # 004c99e7
    # block 0x004c99e9: entered by fall-through of jge at 0x004c99e7, 3 instruction(s), ends with forward jump to 0x004c99f7
    mov ecx, dword ptr [ebp - local_14]          # 004c99e9
    mov dword ptr [ebp - local_40], ecx          # 004c99ec
    jmp.d8 L_004c99f7                            # 004c99ef
L_004c99f1:
    # block 0x004c99f1: entered by jge at 0x004c99e7, 2 instruction(s), falls into the block at 0x004c99f7
    mov edx, dword ptr [ebp - local_4]           # 004c99f1
    mov dword ptr [ebp - local_40], edx          # 004c99f4
L_004c99f7:
    # block 0x004c99f7: entered by jmp at 0x004c99ef, 5 instruction(s), ends with jge to 0x004c9a0d (forward)
    mov eax, dword ptr [ebp - local_40]          # 004c99f7
    mov dword ptr [ebp - local_14], eax          # 004c99fa
    mov ecx, dword ptr [ebp - local_c]           # 004c99fd
    cmp ecx, dword ptr [ebp - local_4]           # 004c9a00
    jge.d8 L_004c9a0d                            # 004c9a03
    # block 0x004c9a05: entered by fall-through of jge at 0x004c9a03, 3 instruction(s), ends with forward jump to 0x004c9a13
    mov edx, dword ptr [ebp - local_c]           # 004c9a05
    mov dword ptr [ebp - local_44], edx          # 004c9a08
    jmp.d8 L_004c9a13                            # 004c9a0b
L_004c9a0d:
    # block 0x004c9a0d: entered by jge at 0x004c9a03, 2 instruction(s), falls into the block at 0x004c9a13
    mov eax, dword ptr [ebp - local_4]           # 004c9a0d
    mov dword ptr [ebp - local_44], eax          # 004c9a10
L_004c9a13:
    # block 0x004c9a13: entered by jmp at 0x004c9a0b, 33 instruction(s), ends with backward jump to 0x004c993d
    mov ecx, dword ptr [ebp - local_44]          # 004c9a13
    mov dword ptr [ebp - local_c], ecx           # 004c9a16
    {load} xor edx, edx                          # 004c9a19
    cmp dword ptr [ebp - local_8], 0x0           # 004c9a1b
    setle dl                                     # 004c9a1f
    dec edx                                      # 004c9a22
    and edx, dword ptr [ebp - local_8]           # 004c9a23
    mov dword ptr [ebp - local_8], edx           # 004c9a26
    {load} xor eax, eax                          # 004c9a29
    cmp dword ptr [ebp - local_14], 0x0          # 004c9a2b
    setle al                                     # 004c9a2f
    dec eax                                      # 004c9a32
    and eax, dword ptr [ebp - local_14]          # 004c9a33
    mov dword ptr [ebp - local_14], eax          # 004c9a36
    {load} xor ecx, ecx                          # 004c9a39
    cmp dword ptr [ebp - local_c], 0x0           # 004c9a3b
    setle cl                                     # 004c9a3f
    dec ecx                                      # 004c9a42
    and ecx, dword ptr [ebp - local_c]           # 004c9a43
    mov dword ptr [ebp - local_c], ecx           # 004c9a46
    mov edx, dword ptr [ebp - local_18]          # 004c9a49
    mov eax, dword ptr [ebp - local_1c]          # 004c9a4c
    mov cx, word ptr [ebp - local_8]             # 004c9a4f
    mov word ptr [eax + 2*edx + field_64a], cx   # 004c9a53
    mov edx, dword ptr [ebp - local_18]          # 004c9a5b
    mov eax, dword ptr [ebp - local_1c]          # 004c9a5e
    mov cx, word ptr [ebp - local_14]            # 004c9a61
    mov word ptr [eax + 2*edx + field_84a], cx   # 004c9a65
    mov edx, dword ptr [ebp - local_18]          # 004c9a6d
    mov eax, dword ptr [ebp - local_1c]          # 004c9a70
    mov cx, word ptr [ebp - local_c]             # 004c9a73
    mov word ptr [eax + 2*edx + field_a4a], cx   # 004c9a77
    jmp.d32 L_004c993d                           # 004c9a7f
L_004c9a84:
    # block 0x004c9a84: entered by jmp at 0x004c992f; jge at 0x004c994d, 3 instruction(s), ends with je to 0x004c9ab8 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c9a84
    cmp dword ptr [edx + field_c4a], 0x0         # 004c9a87
    je.d8 L_004c9ab8                             # 004c9a8e
    # block 0x004c9a90: entered by fall-through of je at 0x004c9a8e, 14 instruction(s), calls indirect dword ptr [eax + 0x10], ends with forward jump to 0x004c9adf
    mov eax, dword ptr [ebp - local_1c]          # 004c9a90
    add eax, 0x64a                               # 004c9a93
    push eax                                     # 004c9a98
    push 0x1                                     # 004c9a99
    mov ecx, dword ptr [ebp - local_1c]          # 004c9a9b
    mov edx, dword ptr [ecx + field_46]          # 004c9a9e
    mov eax, dword ptr [ebp - local_1c]          # 004c9aa1
    mov ecx, dword ptr [eax + field_46]          # 004c9aa4
    mov eax, dword ptr [ecx]                     # 004c9aa7
    push edx                                     # 004c9aa9
    call dword ptr [eax + field_10]              # 004c9aaa
    mov ecx, dword ptr [ebp - local_1c]          # 004c9aad
    mov dword ptr [ecx + field_e82], eax         # 004c9ab0
    jmp.d8 L_004c9adf                            # 004c9ab6
L_004c9ab8:
    # block 0x004c9ab8: entered by je at 0x004c9a8e, 13 instruction(s), calls indirect dword ptr [edx + 0x10], falls into the block at 0x004c9adf
    mov edx, dword ptr [ebp - local_1c]          # 004c9ab8
    add edx, 0x64a                               # 004c9abb
    push edx                                     # 004c9ac1
    push 0x0                                     # 004c9ac2
    mov eax, dword ptr [ebp - local_1c]          # 004c9ac4
    mov ecx, dword ptr [eax + field_46]          # 004c9ac7
    mov edx, dword ptr [ebp - local_1c]          # 004c9aca
    mov eax, dword ptr [edx + field_46]          # 004c9acd
    mov edx, dword ptr [eax]                     # 004c9ad0
    push ecx                                     # 004c9ad2
    call dword ptr [edx + field_10]              # 004c9ad3
    mov ecx, dword ptr [ebp - local_1c]          # 004c9ad6
    mov dword ptr [ecx + field_e82], eax         # 004c9ad9
L_004c9adf:
    # block 0x004c9adf: entered by jmp at 0x004c9ab6, 3 instruction(s), ends with jge to 0x004c9b1f (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c9adf
    cmp dword ptr [edx + field_e82], 0x0         # 004c9ae2
    jge.d8 L_004c9b1f                            # 004c9ae9
    # block 0x004c9aeb: entered by fall-through of jge at 0x004c9ae9, 12 instruction(s), calls FUN_004c88c7, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004c9b1f
    mov eax, dword ptr [ebp - local_1c]          # 004c9aeb
    mov ecx, dword ptr [eax + field_e82]         # 004c9aee
    push ecx                                     # 004c9af4
    mov ecx, dword ptr [ebp - local_1c]          # 004c9af5
    call FUN_004c88c7                            # 004c9af8
    push eax                                     # 004c9afd
    push 0x557c2c                                # 004c9afe
    mov ecx, 0x583979                            # 004c9b03
    call FUN_0042639d                            # 004c9b08
    mov dword ptr [0x5bb20c], 0x1                # 004c9b0d
    mov ecx, dword ptr [ebp - local_1c]          # 004c9b17
    call FUN_004c97b4                            # 004c9b1a
L_004c9b1f:
    # block 0x004c9b1f: entered by jmp at 0x004c98e1; jge at 0x004c9ae9, 5 instruction(s), ends with ret
    pop edi                                      # 004c9b1f
    pop esi                                      # 004c9b20
    {load} mov esp, ebp                          # 004c9b21
    pop ebp                                      # 004c9b23
    ret                                          # 004c9b24

