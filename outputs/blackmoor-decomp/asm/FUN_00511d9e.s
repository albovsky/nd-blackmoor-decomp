# FUN_00511d9e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511d9e
# extent:       0x00511d9e-0x00511e31 (147 code bytes)
# span:         0x00511d9e-0x00511e31 (code 147, tables 0, padding 0)
# sha256:       7960b7d003a3720e94443db95c145f626a9cf4fe4161ee7cdaeb9976c9be7ed9
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511d9e
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       3 ebp-relative slot(s): local_c, local_10, local_28
# fields:       [eax + n] field_minus_1; [edi + n] field_minus_2
# callees:      calls FUN_00516e4e, FUN_00516dd7, FUN_00511cf7, FUN_00511be0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 66 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_minus_2, 0x2  # offset -0x2
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_28, 0x28  # offset -0x28
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00511be0, .text + (0x00511be0 - 0x401000)
.set FUN_00511cf7, .text + (0x00511cf7 - 0x401000)
.set FUN_00516dd7, .text + (0x00516dd7 - 0x401000)
.set FUN_00516e4e, .text + (0x00516e4e - 0x401000)

.org 0x00511d9e - 0x401000
.globl FUN_00511d9e
FUN_00511d9e:
    # block 0x00511d9e: entry, 36 instruction(s), calls FUN_00516e4e, FUN_00516dd7, ends with jl to 0x00511e17 (forward)
    push ebp                                     # 00511d9e
    {load} mov ebp, esp                          # 00511d9f
    sub esp, 0x28                                # 00511da1
    push ebx                                     # 00511da4
    push esi                                     # 00511da5
    lea eax, [ebp - local_28]                    # 00511da6
    push edi                                     # 00511da9
    push eax                                     # 00511daa
    lea eax, [ebp - local_10]                    # 00511dab
    push eax                                     # 00511dae
    mov eax, dword ptr [ebp + arg_8]             # 00511daf
    push ecx                                     # 00511db2
    push ecx                                     # 00511db3
    fld qword ptr [eax]                          # 00511db4
    fstp qword ptr [esp]                         # 00511db6
    call FUN_00516e4e                            # 00511db9
    mov eax, dword ptr [ebp - local_c]           # 00511dbe
    mov ebx, dword ptr [ebp + arg_10]            # 00511dc1
    lea esi, [eax - field_minus_1]               # 00511dc4
    {load} xor eax, eax                          # 00511dc7
    cmp dword ptr [ebp - local_10], 0x2d         # 00511dc9
    sete al                                      # 00511dcd
    add eax, dword ptr [ebp + arg_c]             # 00511dd0
    {load} mov edi, eax                          # 00511dd3
    lea eax, [ebp - local_10]                    # 00511dd5
    push eax                                     # 00511dd8
    push ebx                                     # 00511dd9
    push edi                                     # 00511dda
    call FUN_00516dd7                            # 00511ddb
    mov eax, dword ptr [ebp - local_c]           # 00511de0
    add esp, 0x1c                                # 00511de3
    dec eax                                      # 00511de6
    {load} cmp esi, eax                          # 00511de7
    setl cl                                      # 00511de9
    cmp eax, -0x4                                # 00511dec
    jl.d8 L_00511e17                             # 00511def
    # block 0x00511df1: entered by fall-through of jl at 0x00511def, 2 instruction(s), ends with jge to 0x00511e17 (forward)
    {load} cmp eax, ebx                          # 00511df1
    jge.d8 L_00511e17                            # 00511df3
    # block 0x00511df5: entered by fall-through of jge at 0x00511df3, 2 instruction(s), ends with je to 0x00511e03 (forward)
    test cl, cl                                  # 00511df5
    je.d8 L_00511e03                             # 00511df7
L_00511df9:
    # block 0x00511df9: entered by jne at 0x00511dfe; fall-through of je at 0x00511df7, 4 instruction(s), ends with jne to 0x00511df9 (backward)
    mov al, byte ptr [edi]                       # 00511df9
    inc edi                                      # 00511dfb
    test al, al                                  # 00511dfc
    jne.d8 L_00511df9                            # 00511dfe
    # block 0x00511e00: entered by fall-through of jne at 0x00511dfe, 1 instruction(s), falls into the block at 0x00511e03
    and byte ptr [edi - field_minus_2], al       # 00511e00
L_00511e03:
    # block 0x00511e03: entered by je at 0x00511df7, 8 instruction(s), calls FUN_00511cf7, ends with forward jump to 0x00511e2c
    lea eax, [ebp - local_10]                    # 00511e03
    push 0x1                                     # 00511e06
    push eax                                     # 00511e08
    push ebx                                     # 00511e09
    push dword ptr [ebp + arg_c]                 # 00511e0a
    call FUN_00511cf7                            # 00511e0d
    add esp, 0x10                                # 00511e12
    jmp.d8 L_00511e2c                            # 00511e15
L_00511e17:
    # block 0x00511e17: entered by jl at 0x00511def; jge at 0x00511df3, 8 instruction(s), calls FUN_00511be0, falls into the block at 0x00511e2c
    lea eax, [ebp - local_10]                    # 00511e17
    push 0x1                                     # 00511e1a
    push eax                                     # 00511e1c
    push dword ptr [ebp + arg_14]                # 00511e1d
    push ebx                                     # 00511e20
    push dword ptr [ebp + arg_c]                 # 00511e21
    call FUN_00511be0                            # 00511e24
    add esp, 0x14                                # 00511e29
L_00511e2c:
    # block 0x00511e2c: entered by jmp at 0x00511e15, 5 instruction(s), ends with ret
    pop edi                                      # 00511e2c
    pop esi                                      # 00511e2d
    pop ebx                                      # 00511e2e
    leave                                        # 00511e2f
    ret                                          # 00511e30

