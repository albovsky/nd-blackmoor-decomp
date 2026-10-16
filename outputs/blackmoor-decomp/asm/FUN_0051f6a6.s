# FUN_0051f6a6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f6a6
# extent:       0x0051f6a6-0x0051f7a0 (250 code bytes)
# span:         0x0051f6a6-0x0051f7a0 (code 250, tables 0, padding 0)
# sha256:       626cdb418cfe5ea8e126102c7d0a09d37112aa7224daa2faee06400c1683bcab
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f6a6
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4, field_54; [ebx + n] field_10, field_14, field_18, field_1c, field_20, field_24; [edi + n] field_b8; [esi + n] field_c
# callees:      calls FUN_00525397, FUN_0051ec6f, FUN_0051f8c4, FUN_00525371, FUN_00525b0f, FUN_00510066, FUN_0050e936, FUN_0050ea90; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 87 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_54, 0x54  # offset +0x54
.equ field_b8, 0xb8  # offset +0xb8

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_00510066, .text + (0x00510066 - 0x401000)
.set FUN_0051ec6f, .text + (0x0051ec6f - 0x401000)
.set FUN_0051f8c4, .text + (0x0051f8c4 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00525397, .text + (0x00525397 - 0x401000)
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x0051f6a6 - 0x401000
.globl FUN_0051f6a6
FUN_0051f6a6:
    # block 0x0051f6a6: entry, 11 instruction(s), calls FUN_00525397, ends with je to 0x0051f791 (forward)
    push ebp                                     # 0051f6a6
    {load} mov ebp, esp                          # 0051f6a7
    push ebx                                     # 0051f6a9
    push esi                                     # 0051f6aa
    push edi                                     # 0051f6ab
    call FUN_00525397                            # 0051f6ac
    {load} mov ebx, eax                          # 0051f6b1
    {load} xor esi, esi                          # 0051f6b3
    mov eax, dword ptr [ebx + field_10]          # 0051f6b5
    {load} cmp eax, esi                          # 0051f6b8
    je.d32 L_0051f791                            # 0051f6ba
    # block 0x0051f6c0: entered by fall-through of je at 0x0051f6ba, 4 instruction(s), ends with jne to 0x0051f791 (forward)
    dec eax                                      # 0051f6c0
    {load} cmp eax, esi                          # 0051f6c1
    mov dword ptr [ebx + field_10], eax          # 0051f6c3
    jne.d32 L_0051f791                           # 0051f6c6
    # block 0x0051f6cc: entered by fall-through of jne at 0x0051f6c6, 2 instruction(s), ends with je to 0x0051f713 (forward)
    cmp dword ptr [ebp + arg_8], esi             # 0051f6cc
    je.d8 L_0051f713                             # 0051f6cf
    # block 0x0051f6d1: entered by fall-through of je at 0x0051f6cf, 2 instruction(s), ends with je to 0x0051f6eb (forward)
    cmp dword ptr [ebp + arg_8], -0x1            # 0051f6d1
    je.d8 L_0051f6eb                             # 0051f6d5
    # block 0x0051f6d7: entered by fall-through of je at 0x0051f6d5, 3 instruction(s), calls FUN_0051ec6f, ends with je to 0x0051f6eb (forward)
    call FUN_0051ec6f                            # 0051f6d7
    {load} cmp eax, esi                          # 0051f6dc
    je.d8 L_0051f6eb                             # 0051f6de
    # block 0x0051f6e0: entered by fall-through of je at 0x0051f6de, 3 instruction(s), ends with je to 0x0051f6eb (forward)
    mov eax, dword ptr [eax + field_54]          # 0051f6e0
    {load} cmp eax, esi                          # 0051f6e3
    je.d8 L_0051f6eb                             # 0051f6e5
    # block 0x0051f6e7: entered by fall-through of je at 0x0051f6e5, 3 instruction(s), calls indirect eax, falls into the block at 0x0051f6eb
    push esi                                     # 0051f6e7
    push esi                                     # 0051f6e8
    call eax                                     # 0051f6e9
L_0051f6eb:
    # block 0x0051f6eb: entered by je at 0x0051f6d5; je at 0x0051f6de; je at 0x0051f6e5, 10 instruction(s), calls FUN_0051f8c4, falls into the block at 0x0051f713
    mov ecx, dword ptr [ebx + field_20]          # 0051f6eb
    call FUN_0051f8c4                            # 0051f6ee
    mov ecx, dword ptr [ebx + field_1c]          # 0051f6f3
    call FUN_0051f8c4                            # 0051f6f6
    mov ecx, dword ptr [ebx + field_18]          # 0051f6fb
    call FUN_0051f8c4                            # 0051f6fe
    mov ecx, dword ptr [ebx + field_14]          # 0051f703
    call FUN_0051f8c4                            # 0051f706
    mov ecx, dword ptr [ebx + field_24]          # 0051f70b
    call FUN_0051f8c4                            # 0051f70e
L_0051f713:
    # block 0x0051f713: entered by je at 0x0051f6cf, 8 instruction(s), calls FUN_00525371, FUN_00525b0f, ends with je to 0x0051f791 (forward)
    call FUN_00525371                            # 0051f713
    mov edi, dword ptr [eax + field_4]           # 0051f718
    push 0x52496c                                # 0051f71b
    mov ecx, 0x63c444                            # 0051f720
    call FUN_00525b0f                            # 0051f725
    test edi, edi                                # 0051f72a
    {load} mov esi, eax                          # 0051f72c
    je.d8 L_0051f791                             # 0051f72e
    # block 0x0051f730: entered by fall-through of je at 0x0051f72e, 3 instruction(s), ends with je to 0x0051f746 (forward)
    mov eax, dword ptr [esi + field_c]           # 0051f730
    test eax, eax                                # 0051f733
    je.d8 L_0051f746                             # 0051f735
    # block 0x0051f737: entered by fall-through of je at 0x0051f735, 5 instruction(s), calls FUN_00510066, ends with jae to 0x0051f791 (forward)
    push eax                                     # 0051f737
    call FUN_00510066                            # 0051f738
    cmp eax, dword ptr [edi + field_b8]          # 0051f73d
    pop ecx                                      # 0051f743
    jae.d8 L_0051f791                            # 0051f744
L_0051f746:
    # block 0x0051f746: entered by je at 0x0051f735; fall-through of jae at 0x0051f744, 2 instruction(s), ends with je to 0x0051f791 (forward)
    cmp dword ptr [edi + field_b8], 0x0          # 0051f746
    je.d8 L_0051f791                             # 0051f74d
    # block 0x0051f74f: entered by fall-through of je at 0x0051f74d, 4 instruction(s), ends with je to 0x0051f76d (forward)
    mov eax, dword ptr [esi + field_c]           # 0051f74f
    and dword ptr [ebp + arg_8], 0x0             # 0051f752
    test eax, eax                                # 0051f756
    je.d8 L_0051f76d                             # 0051f758
    # block 0x0051f75a: entered by fall-through of je at 0x0051f758, 7 instruction(s), calls FUN_00510066, FUN_0050e936, falls into the block at 0x0051f76d
    push eax                                     # 0051f75a
    call FUN_00510066                            # 0051f75b
    push dword ptr [esi + field_c]               # 0051f760
    mov dword ptr [ebp + arg_8], eax             # 0051f763
    call FUN_0050e936                            # 0051f766
    pop ecx                                      # 0051f76b
    pop ecx                                      # 0051f76c
L_0051f76d:
    # block 0x0051f76d: entered by je at 0x0051f758, 6 instruction(s), calls FUN_0050ea90, ends with jne to 0x0051f791 (forward)
    push dword ptr [edi + field_b8]              # 0051f76d
    call FUN_0050ea90                            # 0051f773
    test eax, eax                                # 0051f778
    pop ecx                                      # 0051f77a
    mov dword ptr [esi + field_c], eax           # 0051f77b
    jne.d8 L_0051f791                            # 0051f77e
    # block 0x0051f780: entered by fall-through of jne at 0x0051f77e, 2 instruction(s), ends with je to 0x0051f791 (forward)
    cmp dword ptr [ebp + arg_8], eax             # 0051f780
    je.d8 L_0051f791                             # 0051f783
    # block 0x0051f785: entered by fall-through of je at 0x0051f783, 4 instruction(s), calls FUN_0050ea90, falls into the block at 0x0051f791
    push dword ptr [ebp + arg_8]                 # 0051f785
    call FUN_0050ea90                            # 0051f788
    pop ecx                                      # 0051f78d
    mov dword ptr [esi + field_c], eax           # 0051f78e
L_0051f791:
    # block 0x0051f791: entered by je at 0x0051f6ba; jne at 0x0051f6c6; je at 0x0051f72e; jae at 0x0051f744; more, 8 instruction(s), ends with ret 0x4
    {load} xor eax, eax                          # 0051f791
    pop edi                                      # 0051f793
    cmp dword ptr [ebx + field_10], eax          # 0051f794
    pop esi                                      # 0051f797
    pop ebx                                      # 0051f798
    setne al                                     # 0051f799
    pop ebp                                      # 0051f79c
    ret 0x4                                      # 0051f79d

