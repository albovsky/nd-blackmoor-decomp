# FUN_0051b7c1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b7c1
# extent:       0x0051b7c1-0x0051b875 (180 code bytes)
# span:         0x0051b7c1-0x0051b875 (code 180, tables 0, padding 0)
# sha256:       ae4d57b2ef78d3d71ade56f0bd95cd9f04e68d21fed9efbac079d4630165892c
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b7c1
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is not read in the entry block before being written
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_8
# callees:      calls FUN_0052513f, FUN_00525371, USER32.dll!wsprintfA, USER32.dll!GetClassInfoA, FUN_0051b720, FUN_00521014
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 68 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0051b720, .text + (0x0051b720 - 0x401000)
.set FUN_00521014, .text + (0x00521014 - 0x401000)
.set FUN_0052513f, .text + (0x0052513f - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051b7c1 - 0x401000
.globl FUN_0051b7c1
FUN_0051b7c1:
    # block 0x0051b7c1: entry, 14 instruction(s), calls FUN_0052513f, FUN_00525371, ends with jne to 0x0051b802 (forward)
    push ebp                                     # 0051b7c1
    {load} mov ebp, esp                          # 0051b7c2
    sub esp, 0x28                                # 0051b7c4
    push ebx                                     # 0051b7c7
    push esi                                     # 0051b7c8
    push edi                                     # 0051b7c9
    call FUN_0052513f                            # 0051b7ca
    {load} mov esi, eax                          # 0051b7cf
    add esi, 0x58                                # 0051b7d1
    call FUN_00525371                            # 0051b7d4
    mov ebx, dword ptr [ebp + arg_c]             # 0051b7d9
    mov edi, dword ptr [eax + field_8]           # 0051b7dc
    test ebx, ebx                                # 0051b7df
    jne.d8 L_0051b802                            # 0051b7e1
    # block 0x0051b7e3: entered by fall-through of jne at 0x0051b7e1, 2 instruction(s), ends with jne to 0x0051b802 (forward)
    cmp dword ptr [ebp + arg_10], ebx            # 0051b7e3
    jne.d8 L_0051b802                            # 0051b7e6
    # block 0x0051b7e8: entered by fall-through of jne at 0x0051b7e6, 2 instruction(s), ends with jne to 0x0051b802 (forward)
    cmp dword ptr [ebp + arg_14], ebx            # 0051b7e8
    jne.d8 L_0051b802                            # 0051b7eb
    # block 0x0051b7ed: entered by fall-through of jne at 0x0051b7eb, 7 instruction(s), calls USER32.dll!wsprintfA, ends with forward jump to 0x0051b81c
    push dword ptr [ebp + arg_8]                 # 0051b7ed
    push edi                                     # 0051b7f0
    push 0x52eb30                                # 0051b7f1
    push esi                                     # 0051b7f6
    call dword ptr [0x52a3e8]                    # 0051b7f7
    add esp, 0x10                                # 0051b7fd
    jmp.d8 L_0051b81c                            # 0051b800
L_0051b802:
    # block 0x0051b802: entered by jne at 0x0051b7e1; jne at 0x0051b7e6; jne at 0x0051b7eb, 9 instruction(s), calls USER32.dll!wsprintfA, falls into the block at 0x0051b81c
    push dword ptr [ebp + arg_14]                # 0051b802
    push dword ptr [ebp + arg_10]                # 0051b805
    push ebx                                     # 0051b808
    push dword ptr [ebp + arg_8]                 # 0051b809
    push edi                                     # 0051b80c
    push 0x52eb1c                                # 0051b80d
    push esi                                     # 0051b812
    call dword ptr [0x52a3e8]                    # 0051b813
    add esp, 0x1c                                # 0051b819
L_0051b81c:
    # block 0x0051b81c: entered by jmp at 0x0051b800, 7 instruction(s), calls USER32.dll!GetClassInfoA, ends with jne to 0x0051b86c (forward)
    lea eax, [ebp - local_28]                    # 0051b81c
    push eax                                     # 0051b81f
    push esi                                     # 0051b820
    push edi                                     # 0051b821
    call dword ptr [0x52a3ec]                    # 0051b822
    test eax, eax                                # 0051b828
    jne.d8 L_0051b86c                            # 0051b82a
    # block 0x0051b82c: entered by fall-through of jne at 0x0051b82a, 20 instruction(s), calls FUN_0051b720, ends with jne to 0x0051b86c (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0051b82c
    mov ecx, dword ptr [ebp + arg_14]            # 0051b82f
    mov dword ptr [ebp - local_28], eax          # 0051b832
    mov eax, dword ptr [0x52a410]                # 0051b835
    mov dword ptr [ebp - local_24], eax          # 0051b83a
    {load} xor eax, eax                          # 0051b83d
    mov dword ptr [ebp - local_1c], eax          # 0051b83f
    mov dword ptr [ebp - local_20], eax          # 0051b842
    mov dword ptr [ebp - local_8], eax           # 0051b845
    mov dword ptr [ebp - local_14], ecx          # 0051b848
    mov ecx, dword ptr [ebp + arg_10]            # 0051b84b
    lea eax, [ebp - local_28]                    # 0051b84e
    push eax                                     # 0051b851
    mov dword ptr [ebp - local_18], edi          # 0051b852
    mov dword ptr [ebp - local_10], ebx          # 0051b855
    mov dword ptr [ebp - local_c], ecx           # 0051b858
    mov dword ptr [ebp - local_4], esi           # 0051b85b
    call FUN_0051b720                            # 0051b85e
    test eax, eax                                # 0051b863
    jne.d8 L_0051b86c                            # 0051b865
    # block 0x0051b867: entered by fall-through of jne at 0x0051b865, 1 instruction(s), calls FUN_00521014, falls into the block at 0x0051b86c
    call FUN_00521014                            # 0051b867
L_0051b86c:
    # block 0x0051b86c: entered by jne at 0x0051b82a; jne at 0x0051b865, 6 instruction(s), ends with ret 0x10
    {load} mov eax, esi                          # 0051b86c
    pop edi                                      # 0051b86e
    pop esi                                      # 0051b86f
    pop ebx                                      # 0051b870
    leave                                        # 0051b871
    ret 0x10                                     # 0051b872

