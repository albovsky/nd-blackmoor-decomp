# FUN_00508c00
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00508c00
# extent:       0x00508c00-0x00508dbe (446 code bytes)
# span:         0x00508c00-0x00508dc0 (code 446, tables 0, padding 2)
# sha256:       9108f55d5408177ce9930c7587cd37d9475ece00273d8289372cec1df73e570a
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00508bc0 (+0x40)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00508c00
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_4, field_80, field_c0, field_140, field_340, field_348, field_34c; [esi + n] field_1, field_40, field_minus_40; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28
# callees:      calls FUN_0050bc80, FUN_004ff2f0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 162 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00508dc0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_40, 0x40  # offset -0x40
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ field_40, 0x40  # offset +0x40
.equ field_80, 0x80  # offset +0x80
.equ field_c0, 0xc0  # offset +0xc0
.equ field_140, 0x140  # offset +0x140
.equ field_340, 0x340  # offset +0x340
.equ field_348, 0x348  # offset +0x348
.equ field_34c, 0x34c  # offset +0x34c

# --- external targets -----------------------------------------------
.set FUN_004ff2f0, .text + (0x004ff2f0 - 0x401000)
.set FUN_0050bc80, .text + (0x0050bc80 - 0x401000)

.org 0x00508c00 - 0x401000
.globl FUN_00508c00
FUN_00508c00:
    # block 0x00508c00: entry, 22 instruction(s), calls FUN_0050bc80, ends with jle to 0x00508c68 (forward)
    sub esp, 0xc                                 # 00508c00
    push ebx                                     # 00508c03
    push ebp                                     # 00508c04
    mov ebp, dword ptr [esp + stk_18]            # 00508c05
    push esi                                     # 00508c09
    push edi                                     # 00508c0a
    mov edi, dword ptr [esp + stk_24]            # 00508c0b
    {disp8} mov ecx, dword ptr [ebp]             # 00508c0f
    mov eax, dword ptr [ebp + field_348]         # 00508c12
    push 0x5                                     # 00508c18
    {load} xor ebx, ebx                          # 00508c1a
    push ecx                                     # 00508c1c
    push edi                                     # 00508c1d
    mov dword ptr [esp + stk_1c], ebx            # 00508c1e
    mov dword ptr [esp + stk_24], eax            # 00508c22
    or esi, -0x1                                 # 00508c26
    call FUN_0050bc80                            # 00508c29
    {disp8} mov eax, dword ptr [ebp]             # 00508c2e
    add esp, 0xc                                 # 00508c31
    {load} cmp eax, ebx                          # 00508c34
    mov dword ptr [esp + stk_24], ebx            # 00508c36
    jle.d8 L_00508c68                            # 00508c3a
    # block 0x00508c3c: entered by fall-through of jle at 0x00508c3a, 1 instruction(s), falls into the block at 0x00508c3f
    lea ebx, [ebp + field_4]                     # 00508c3c
L_00508c3f:
    # block 0x00508c3f: entered by jl at 0x00508c66, 9 instruction(s), calls FUN_0050bc80, ends with jge to 0x00508c55 (forward)
    mov edx, dword ptr [ebx]                     # 00508c3f
    push 0x4                                     # 00508c41
    push edx                                     # 00508c43
    push edi                                     # 00508c44
    call FUN_0050bc80                            # 00508c45
    mov eax, dword ptr [ebx]                     # 00508c4a
    add esp, 0xc                                 # 00508c4c
    {load} cmp esi, eax                          # 00508c4f
    jge.d8 L_00508c55                            # 00508c51
    # block 0x00508c53: entered by fall-through of jge at 0x00508c51, 1 instruction(s), falls into the block at 0x00508c55
    {load} mov esi, eax                          # 00508c53
L_00508c55:
    # block 0x00508c55: entered by jge at 0x00508c51, 7 instruction(s), ends with jl to 0x00508c3f (backward)
    mov eax, dword ptr [esp + stk_24]            # 00508c55
    {disp8} mov ecx, dword ptr [ebp]             # 00508c59
    inc eax                                      # 00508c5c
    add ebx, 0x4                                 # 00508c5d
    {load} cmp eax, ecx                          # 00508c60
    mov dword ptr [esp + stk_24], eax            # 00508c62
    jl.d8 L_00508c3f                             # 00508c66
L_00508c68:
    # block 0x00508c68: entered by jle at 0x00508c3a; fall-through of jl at 0x00508c66, 3 instruction(s), ends with jle to 0x00508d0c (forward)
    lea eax, [esi + field_1]                     # 00508c68
    test eax, eax                                # 00508c6b
    jle.d32 L_00508d0c                           # 00508c6d
    # block 0x00508c73: entered by fall-through of jle at 0x00508c6d, 4 instruction(s), falls into the block at 0x00508c87
    lea ecx, [ebp + field_140]                   # 00508c73
    lea esi, [ebp + field_c0]                    # 00508c79
    mov dword ptr [esp + stk_24], ecx            # 00508c7f
    mov dword ptr [esp + stk_14], eax            # 00508c83
L_00508c87:
    # block 0x00508c87: entered by jne at 0x00508d06, 15 instruction(s), calls FUN_0050bc80, ends with je to 0x00508cb7 (forward)
    mov edx, dword ptr [esi - field_minus_40]    # 00508c87
    push 0x3                                     # 00508c8a
    dec edx                                      # 00508c8c
    push edx                                     # 00508c8d
    push edi                                     # 00508c8e
    call FUN_0050bc80                            # 00508c8f
    mov eax, dword ptr [esi]                     # 00508c94
    push 0x2                                     # 00508c96
    push eax                                     # 00508c98
    push edi                                     # 00508c99
    call FUN_0050bc80                            # 00508c9a
    mov eax, dword ptr [esi]                     # 00508c9f
    add esp, 0x18                                # 00508ca1
    test eax, eax                                # 00508ca4
    je.d8 L_00508cb7                             # 00508ca6
    # block 0x00508ca8: entered by fall-through of je at 0x00508ca6, 6 instruction(s), calls FUN_0050bc80, falls into the block at 0x00508cb7
    mov ecx, dword ptr [esi + field_40]          # 00508ca8
    push 0x8                                     # 00508cab
    push ecx                                     # 00508cad
    push edi                                     # 00508cae
    call FUN_0050bc80                            # 00508caf
    add esp, 0xc                                 # 00508cb4
L_00508cb7:
    # block 0x00508cb7: entered by je at 0x00508ca6, 6 instruction(s), ends with jle to 0x00508cef (forward)
    mov ecx, dword ptr [esi]                     # 00508cb7
    mov edx, 0x1                                 # 00508cb9
    shl edx, cl                                  # 00508cbe
    {load} xor ebx, ebx                          # 00508cc0
    test edx, edx                                # 00508cc2
    jle.d8 L_00508cef                            # 00508cc4
    # block 0x00508cc6: entered by fall-through of jle at 0x00508cc4, 1 instruction(s), falls into the block at 0x00508cca
    mov ebp, dword ptr [esp + stk_24]            # 00508cc6
L_00508cca:
    # block 0x00508cca: entered by jl at 0x00508ce9, 14 instruction(s), calls FUN_0050bc80, ends with jl to 0x00508cca (backward)
    {disp8} mov eax, dword ptr [ebp]             # 00508cca
    push 0x8                                     # 00508ccd
    inc eax                                      # 00508ccf
    push eax                                     # 00508cd0
    push edi                                     # 00508cd1
    call FUN_0050bc80                            # 00508cd2
    mov ecx, dword ptr [esi]                     # 00508cd7
    mov edx, 0x1                                 # 00508cd9
    shl edx, cl                                  # 00508cde
    add esp, 0xc                                 # 00508ce0
    inc ebx                                      # 00508ce3
    add ebp, 0x4                                 # 00508ce4
    {load} cmp ebx, edx                          # 00508ce7
    jl.d8 L_00508cca                             # 00508ce9
    # block 0x00508ceb: entered by fall-through of jl at 0x00508ce9, 1 instruction(s), falls into the block at 0x00508cef
    mov ebp, dword ptr [esp + stk_20]            # 00508ceb
L_00508cef:
    # block 0x00508cef: entered by jle at 0x00508cc4, 8 instruction(s), ends with jne to 0x00508c87 (backward)
    mov ecx, dword ptr [esp + stk_24]            # 00508cef
    mov eax, dword ptr [esp + stk_14]            # 00508cf3
    add esi, 0x4                                 # 00508cf7
    add ecx, 0x20                                # 00508cfa
    dec eax                                      # 00508cfd
    mov dword ptr [esp + stk_24], ecx            # 00508cfe
    mov dword ptr [esp + stk_14], eax            # 00508d02
    jne.d32 L_00508c87                           # 00508d06
L_00508d0c:
    # block 0x00508d0c: entered by jle at 0x00508c6d; fall-through of jne at 0x00508d06, 24 instruction(s), calls FUN_0050bc80, FUN_004ff2f0, ends with jle to 0x00508db6 (forward)
    mov eax, dword ptr [ebp + field_340]         # 00508d0c
    push 0x2                                     # 00508d12
    dec eax                                      # 00508d14
    push eax                                     # 00508d15
    push edi                                     # 00508d16
    call FUN_0050bc80                            # 00508d17
    mov esi, dword ptr [esp + stk_24]            # 00508d1c
    add esp, 0xc                                 # 00508d20
    push 0x4                                     # 00508d23
    push esi                                     # 00508d25
    call FUN_004ff2f0                            # 00508d26
    add esp, 0x4                                 # 00508d2b
    push eax                                     # 00508d2e
    push edi                                     # 00508d2f
    call FUN_0050bc80                            # 00508d30
    push esi                                     # 00508d35
    call FUN_004ff2f0                            # 00508d36
    {disp8} mov ecx, dword ptr [ebp]             # 00508d3b
    mov dword ptr [esp + stk_28], eax            # 00508d3e
    {load} xor eax, eax                          # 00508d42
    add esp, 0x10                                # 00508d44
    {load} cmp ecx, eax                          # 00508d47
    mov dword ptr [esp + stk_24], eax            # 00508d49
    jle.d8 L_00508db6                            # 00508d4d
    # block 0x00508d4f: entered by fall-through of jle at 0x00508d4d, 2 instruction(s), falls into the block at 0x00508d56
    lea ecx, [ebp + field_4]                     # 00508d4f
    mov dword ptr [esp + stk_20], ecx            # 00508d52
L_00508d56:
    # block 0x00508d56: entered by jl at 0x00508db4, 7 instruction(s), ends with jge to 0x00508d9b (forward)
    mov edx, dword ptr [esp + stk_20]            # 00508d56
    mov ecx, dword ptr [esp + stk_10]            # 00508d5a
    mov edx, dword ptr [edx]                     # 00508d5e
    add ecx, dword ptr [ebp + 4*edx + field_80]  # 00508d60
    {load} cmp eax, ecx                          # 00508d67
    mov dword ptr [esp + stk_10], ecx            # 00508d69
    jge.d8 L_00508d9b                            # 00508d6d
    # block 0x00508d6f: entered by fall-through of jge at 0x00508d6d, 5 instruction(s), falls into the block at 0x00508d80
    {load} mov esi, ecx                          # 00508d6f
    lea ebx, [ebp + 4*eax + field_34c]           # 00508d71
    {load} sub esi, eax                          # 00508d78
    {load} add eax, esi                          # 00508d7a
    mov dword ptr [esp + stk_14], eax            # 00508d7c
L_00508d80:
    # block 0x00508d80: entered by jne at 0x00508d95, 10 instruction(s), calls FUN_0050bc80, ends with jne to 0x00508d80 (backward)
    mov eax, dword ptr [esp + stk_18]            # 00508d80
    mov ecx, dword ptr [ebx]                     # 00508d84
    push eax                                     # 00508d86
    push ecx                                     # 00508d87
    push edi                                     # 00508d88
    call FUN_0050bc80                            # 00508d89
    add esp, 0xc                                 # 00508d8e
    add ebx, 0x4                                 # 00508d91
    dec esi                                      # 00508d94
    jne.d8 L_00508d80                            # 00508d95
    # block 0x00508d97: entered by fall-through of jne at 0x00508d95, 1 instruction(s), falls into the block at 0x00508d9b
    mov eax, dword ptr [esp + stk_14]            # 00508d97
L_00508d9b:
    # block 0x00508d9b: entered by jge at 0x00508d6d, 9 instruction(s), ends with jl to 0x00508d56 (backward)
    mov ecx, dword ptr [esp + stk_24]            # 00508d9b
    mov esi, dword ptr [esp + stk_20]            # 00508d9f
    {disp8} mov edx, dword ptr [ebp]             # 00508da3
    inc ecx                                      # 00508da6
    add esi, 0x4                                 # 00508da7
    {load} cmp ecx, edx                          # 00508daa
    mov dword ptr [esp + stk_24], ecx            # 00508dac
    mov dword ptr [esp + stk_20], esi            # 00508db0
    jl.d8 L_00508d56                             # 00508db4
L_00508db6:
    # block 0x00508db6: entered by jle at 0x00508d4d; fall-through of jl at 0x00508db4, 6 instruction(s), ends with ret
    pop edi                                      # 00508db6
    pop esi                                      # 00508db7
    pop ebp                                      # 00508db8
    pop ebx                                      # 00508db9
    add esp, 0xc                                 # 00508dba
    ret                                          # 00508dbd

# --- data items (not part of the function) -------------------------
.org 0x00508dbe - 0x401000
PAD_00508dbe:  # 2 byte(s) of nop padding
    .fill 2, 1, 0x90

