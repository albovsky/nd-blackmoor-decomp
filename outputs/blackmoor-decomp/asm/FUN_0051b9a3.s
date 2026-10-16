# FUN_0051b9a3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b9a3
# extent:       0x0051b9a3-0x0051b9e3 (64 code bytes)
# span:         0x0051b9a3-0x0051b9e3 (code 64, tables 0, padding 0)
# sha256:       dd5ef94bd2d0a196776d9058a1c71c449965f9d458fa6d17bcc111eb56030f95
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b9a3
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [ebx + n] field_4, field_8, field_c, field_10
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------

.org 0x0051b9a3 - 0x401000
.globl FUN_0051b9a3
FUN_0051b9a3:
    # block 0x0051b9a3: entry, 7 instruction(s), falls into the block at 0x0051b9b3
    push ebp                                     # 0051b9a3
    {load} mov ebp, esp                          # 0051b9a4
    push ebx                                     # 0051b9a6
    mov ebx, dword ptr [ebp + arg_8]             # 0051b9a7
    mov eax, dword ptr [ebp + arg_c]             # 0051b9aa
    mov edx, dword ptr [ebp + arg_10]            # 0051b9ad
    mov ecx, dword ptr [ebp + arg_14]            # 0051b9b0
L_0051b9b3:
    # block 0x0051b9b3: entered by jmp at 0x0051b9c0, 2 instruction(s), ends with je to 0x0051b9d6 (forward)
    cmp dword ptr [ebx + field_10], 0x0          # 0051b9b3
    je.d8 L_0051b9d6                             # 0051b9b7
    # block 0x0051b9b9: entered by fall-through of je at 0x0051b9b7, 2 instruction(s), ends with je to 0x0051b9c2 (forward)
    cmp eax, dword ptr [ebx]                     # 0051b9b9
    je.d8 L_0051b9c2                             # 0051b9bb
L_0051b9bd:
    # block 0x0051b9bd: entered by jne at 0x0051b9c5; jb at 0x0051b9ca; ja at 0x0051b9cf; fall-through of je at 0x0051b9bb, 2 instruction(s), ends with backward jump to 0x0051b9b3
    add ebx, 0x18                                # 0051b9bd
    jmp.d8 L_0051b9b3                            # 0051b9c0
L_0051b9c2:
    # block 0x0051b9c2: entered by je at 0x0051b9bb, 2 instruction(s), ends with jne to 0x0051b9bd (backward)
    cmp edx, dword ptr [ebx + field_4]           # 0051b9c2
    jne.d8 L_0051b9bd                            # 0051b9c5
    # block 0x0051b9c7: entered by fall-through of jne at 0x0051b9c5, 2 instruction(s), ends with jb to 0x0051b9bd (backward)
    cmp ecx, dword ptr [ebx + field_8]           # 0051b9c7
    jb.d8 L_0051b9bd                             # 0051b9ca
    # block 0x0051b9cc: entered by fall-through of jb at 0x0051b9ca, 2 instruction(s), ends with ja to 0x0051b9bd (backward)
    cmp ecx, dword ptr [ebx + field_c]           # 0051b9cc
    ja.d8 L_0051b9bd                             # 0051b9cf
    # block 0x0051b9d1: entered by fall-through of ja at 0x0051b9cf, 2 instruction(s), ends with forward jump to 0x0051b9db
    mov dword ptr [ebp + arg_8], ebx             # 0051b9d1
    jmp.d8 L_0051b9db                            # 0051b9d4
L_0051b9d6:
    # block 0x0051b9d6: entered by je at 0x0051b9b7, 2 instruction(s), falls into the block at 0x0051b9db
    {load} xor eax, eax                          # 0051b9d6
    mov dword ptr [ebp + arg_8], eax             # 0051b9d8
L_0051b9db:
    # block 0x0051b9db: entered by jmp at 0x0051b9d4, 4 instruction(s), ends with ret 0x10
    mov eax, dword ptr [ebp + arg_8]             # 0051b9db
    pop ebx                                      # 0051b9de
    pop ebp                                      # 0051b9df
    ret 0x10                                     # 0051b9e0

