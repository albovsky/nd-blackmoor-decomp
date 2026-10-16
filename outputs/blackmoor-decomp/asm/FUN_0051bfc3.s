# FUN_0051bfc3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051bfc3
# extent:       0x0051bfc3-0x0051c04f (140 code bytes)
# span:         0x0051bfc3-0x0051c04f (code 140, tables 0, padding 0)
# sha256:       1d1cfb002873c26ee89c8f2dd9c665adf93a3aa4a9a22a3295a6129670944d7c
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051bfc3
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_28, local_2c
# fields:       [eax + n] field_c, field_b8; [esi + n] field_1c
# callees:      calls FUN_0051bf99, FUN_00525b0f, FUN_0051c519; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 60 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_b8, 0xb8  # offset +0xb8

# --- external targets -----------------------------------------------
.set FUN_0051bf99, .text + (0x0051bf99 - 0x401000)
.set FUN_0051c519, .text + (0x0051c519 - 0x401000)
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x0051bfc3 - 0x401000
.globl FUN_0051bfc3
FUN_0051bfc3:
    # block 0x0051bfc3: entry, 14 instruction(s), ends with jne to 0x0051c01b (forward)
    push ebp                                     # 0051bfc3
    {load} mov ebp, esp                          # 0051bfc4
    sub esp, 0x2c                                # 0051bfc6
    mov eax, dword ptr [ebp + arg_8]             # 0051bfc9
    push ebx                                     # 0051bfcc
    push esi                                     # 0051bfcd
    push edi                                     # 0051bfce
    movzx edi, ax                                # 0051bfcf
    {load} xor ebx, ebx                          # 0051bfd2
    {load} mov esi, ecx                          # 0051bfd4
    shr eax, 0x10                                # 0051bfd6
    cmp dword ptr [ebp + arg_c], ebx             # 0051bfd9
    mov dword ptr [ebp + arg_8], eax             # 0051bfdc
    jne.d8 L_0051c01b                            # 0051bfdf
    # block 0x0051bfe1: entered by fall-through of jne at 0x0051bfdf, 2 instruction(s), ends with je to 0x0051c04b (forward)
    {load} cmp edi, ebx                          # 0051bfe1
    je.d8 L_0051c04b                             # 0051bfe3
    # block 0x0051bfe5: entered by fall-through of je at 0x0051bfe3, 13 instruction(s), calls FUN_0051bf99, indirect dword ptr [eax + 0xc], ends with je to 0x0051c042 (forward)
    lea ecx, [ebp - local_2c]                    # 0051bfe5
    call FUN_0051bf99                            # 0051bfe8
    mov eax, dword ptr [esi]                     # 0051bfed
    lea ecx, [ebp - local_2c]                    # 0051bfef
    push ebx                                     # 0051bff2
    push ecx                                     # 0051bff3
    push -0x1                                    # 0051bff4
    push edi                                     # 0051bff6
    {load} mov ecx, esi                          # 0051bff7
    mov dword ptr [ebp - local_28], edi          # 0051bff9
    call dword ptr [eax + field_c]               # 0051bffc
    cmp dword ptr [ebp - local_4], ebx           # 0051bfff
    je.d8 L_0051c042                             # 0051c002
    # block 0x0051c004: entered by fall-through of je at 0x0051c002, 1 instruction(s), falls into the block at 0x0051c007
    mov dword ptr [ebp + arg_8], ebx             # 0051c004
L_0051c007:
    # block 0x0051c007: entered by jne at 0x0051c049, 7 instruction(s), calls indirect dword ptr [eax + 0xc], falls into the block at 0x0051c014
    mov eax, dword ptr [esi]                     # 0051c007
    push ebx                                     # 0051c009
    push ebx                                     # 0051c00a
    {load} mov ecx, esi                          # 0051c00b
    push dword ptr [ebp + arg_8]                 # 0051c00d
    push edi                                     # 0051c010
    call dword ptr [eax + field_c]               # 0051c011
L_0051c014:
    # block 0x0051c014: entered by jmp at 0x0051c045; jmp at 0x0051c04d, 5 instruction(s), ends with ret 0x8
    pop edi                                      # 0051c014
    pop esi                                      # 0051c015
    pop ebx                                      # 0051c016
    leave                                        # 0051c017
    ret 0x8                                      # 0051c018
L_0051c01b:
    # block 0x0051c01b: entered by jne at 0x0051bfdf, 6 instruction(s), calls FUN_00525b0f, ends with je to 0x0051c042 (forward)
    push 0x52496c                                # 0051c01b
    mov ecx, 0x63c444                            # 0051c020
    call FUN_00525b0f                            # 0051c025
    mov eax, dword ptr [eax + field_b8]          # 0051c02a
    cmp eax, dword ptr [esi + field_1c]          # 0051c030
    je.d8 L_0051c042                             # 0051c033
    # block 0x0051c035: entered by fall-through of je at 0x0051c033, 5 instruction(s), calls FUN_0051c519, ends with je to 0x0051c047 (forward)
    push ebx                                     # 0051c035
    push dword ptr [ebp + arg_c]                 # 0051c036
    call FUN_0051c519                            # 0051c039
    test eax, eax                                # 0051c03e
    je.d8 L_0051c047                             # 0051c040
L_0051c042:
    # block 0x0051c042: entered by je at 0x0051c002; je at 0x0051c033; fall-through of je at 0x0051c040, 3 instruction(s), ends with backward jump to 0x0051c014
    push 0x1                                     # 0051c042
    pop eax                                      # 0051c044
    jmp.d8 L_0051c014                            # 0051c045
L_0051c047:
    # block 0x0051c047: entered by je at 0x0051c040, 2 instruction(s), ends with jne to 0x0051c007 (backward)
    {load} cmp edi, ebx                          # 0051c047
    jne.d8 L_0051c007                            # 0051c049
L_0051c04b:
    # block 0x0051c04b: entered by je at 0x0051bfe3; fall-through of jne at 0x0051c049, 2 instruction(s), ends with backward jump to 0x0051c014
    {load} xor eax, eax                          # 0051c04b
    jmp.d8 L_0051c014                            # 0051c04d

