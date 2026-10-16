# FUN_00508dc0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00508dc0
# extent:       0x00508dc0-0x00508fea (554 code bytes)
# span:         0x00508dc0-0x00508ff0 (code 554, tables 0, padding 6)
# sha256:       5c12c4a8e30c7645d0f7fb6ee329f0a906de5bec1296ff0e7113e93f0c9447c1
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00508bc0 (+0x200)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00508dc0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c; [ebp + n] field_4, field_80, field_100, field_140, field_340, field_344, field_348, field_34c; [ecx + n] field_18; [esi + n] field_minus_40, field_minus_80; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_30
# callees:      calls FUN_0050e97e, FUN_0050be60, FUN_00508bc0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 185 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00508ff0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_40, 0x40  # offset -0x40
.equ field_minus_80, 0x80  # offset -0x80
.equ field_4, 0x4  # offset +0x4
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ field_80, 0x80  # offset +0x80
.equ field_100, 0x100  # offset +0x100
.equ field_140, 0x140  # offset +0x140
.equ field_340, 0x340  # offset +0x340
.equ field_344, 0x344  # offset +0x344
.equ field_348, 0x348  # offset +0x348
.equ field_34c, 0x34c  # offset +0x34c

# --- external targets -----------------------------------------------
.set FUN_00508bc0, .text + (0x00508bc0 - 0x401000)
.set FUN_0050be60, .text + (0x0050be60 - 0x401000)
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)

.org 0x00508dc0 - 0x401000
.globl FUN_00508dc0
FUN_00508dc0:
    # block 0x00508dc0: entry, 24 instruction(s), calls FUN_0050e97e, FUN_0050be60, ends with jle to 0x00508e34 (forward)
    sub esp, 0x10                                # 00508dc0
    mov eax, dword ptr [esp + stk_14]            # 00508dc3
    push ebx                                     # 00508dc7
    push ebp                                     # 00508dc8
    push esi                                     # 00508dc9
    mov ecx, dword ptr [eax + field_1c]          # 00508dca
    push edi                                     # 00508dcd
    {load} xor esi, esi                          # 00508dce
    push 0x460                                   # 00508dd0
    push 0x1                                     # 00508dd5
    mov dword ptr [esp + stk_20], ecx            # 00508dd7
    mov dword ptr [esp + stk_18], esi            # 00508ddb
    or edi, -0x1                                 # 00508ddf
    call FUN_0050e97e                            # 00508de2
    mov ebx, dword ptr [esp + stk_30]            # 00508de7
    {load} mov ebp, eax                          # 00508deb
    push 0x5                                     # 00508ded
    push ebx                                     # 00508def
    mov dword ptr [esp + stk_24], ebp            # 00508df0
    call FUN_0050be60                            # 00508df4
    add esp, 0x10                                # 00508df9
    {disp8} mov dword ptr [ebp], eax             # 00508dfc
    test eax, eax                                # 00508dff
    jle.d8 L_00508e34                            # 00508e01
    # block 0x00508e03: entered by fall-through of jle at 0x00508e01, 2 instruction(s), falls into the block at 0x00508e0a
    lea edx, [ebp + field_4]                     # 00508e03
    mov dword ptr [esp + stk_24], edx            # 00508e06
L_00508e0a:
    # block 0x00508e0a: entered by jl at 0x00508e32, 8 instruction(s), calls FUN_0050be60, ends with jge to 0x00508e21 (forward)
    push 0x4                                     # 00508e0a
    push ebx                                     # 00508e0c
    call FUN_0050be60                            # 00508e0d
    mov ecx, dword ptr [esp + stk_2c]            # 00508e12
    add esp, 0x8                                 # 00508e16
    {load} cmp edi, eax                          # 00508e19
    mov dword ptr [ecx], eax                     # 00508e1b
    jge.d8 L_00508e21                            # 00508e1d
    # block 0x00508e1f: entered by fall-through of jge at 0x00508e1d, 1 instruction(s), falls into the block at 0x00508e21
    {load} mov edi, eax                          # 00508e1f
L_00508e21:
    # block 0x00508e21: entered by jge at 0x00508e1d, 7 instruction(s), ends with jl to 0x00508e0a (backward)
    mov ecx, dword ptr [esp + stk_24]            # 00508e21
    {disp8} mov eax, dword ptr [ebp]             # 00508e25
    inc esi                                      # 00508e28
    add ecx, 0x4                                 # 00508e29
    {load} cmp esi, eax                          # 00508e2c
    mov dword ptr [esp + stk_24], ecx            # 00508e2e
    jl.d8 L_00508e0a                             # 00508e32
L_00508e34:
    # block 0x00508e34: entered by jle at 0x00508e01; fall-through of jl at 0x00508e32, 5 instruction(s), ends with jle to 0x00508f12 (forward)
    inc edi                                      # 00508e34
    mov dword ptr [esp + stk_24], 0x0            # 00508e35
    test edi, edi                                # 00508e3d
    mov dword ptr [esp + stk_1c], edi            # 00508e3f
    jle.d32 L_00508f12                           # 00508e43
    # block 0x00508e49: entered by fall-through of jle at 0x00508e43, 3 instruction(s), falls into the block at 0x00508e59
    lea edx, [ebp + field_140]                   # 00508e49
    lea esi, [ebp + field_100]                   # 00508e4f
    mov dword ptr [esp + stk_28], edx            # 00508e55
L_00508e59:
    # block 0x00508e59: entered by jl at 0x00508f0c, 12 instruction(s), calls FUN_0050be60, ends with jl to 0x00508fd7 (forward)
    push 0x3                                     # 00508e59
    push ebx                                     # 00508e5b
    call FUN_0050be60                            # 00508e5c
    inc eax                                      # 00508e61
    push 0x2                                     # 00508e62
    push ebx                                     # 00508e64
    mov dword ptr [esi - field_minus_80], eax    # 00508e65
    call FUN_0050be60                            # 00508e68
    add esp, 0x10                                # 00508e6d
    mov dword ptr [esi - field_minus_40], eax    # 00508e70
    test eax, eax                                # 00508e73
    jl.d32 L_00508fd7                            # 00508e75
    # block 0x00508e7b: entered by fall-through of jl at 0x00508e75, 1 instruction(s), ends with je to 0x00508e8a (forward)
    je.d8 L_00508e8a                             # 00508e7b
    # block 0x00508e7d: entered by fall-through of je at 0x00508e7b, 5 instruction(s), calls FUN_0050be60, falls into the block at 0x00508e8a
    push 0x8                                     # 00508e7d
    push ebx                                     # 00508e7f
    call FUN_0050be60                            # 00508e80
    add esp, 0x8                                 # 00508e85
    mov dword ptr [esi], eax                     # 00508e88
L_00508e8a:
    # block 0x00508e8a: entered by je at 0x00508e7b, 3 instruction(s), ends with jl to 0x00508fd7 (forward)
    mov eax, dword ptr [esi]                     # 00508e8a
    test eax, eax                                # 00508e8c
    jl.d32 L_00508fd7                            # 00508e8e
    # block 0x00508e94: entered by fall-through of jl at 0x00508e8e, 3 instruction(s), ends with jge to 0x00508fd7 (forward)
    mov ecx, dword ptr [esp + stk_18]            # 00508e94
    cmp eax, dword ptr [ecx + field_18]          # 00508e98
    jge.d32 L_00508fd7                           # 00508e9b
    # block 0x00508ea1: entered by fall-through of jge at 0x00508e9b, 6 instruction(s), ends with jle to 0x00508eef (forward)
    mov ecx, dword ptr [esi - field_minus_40]    # 00508ea1
    mov edx, 0x1                                 # 00508ea4
    shl edx, cl                                  # 00508ea9
    {load} xor ebp, ebp                          # 00508eab
    test edx, edx                                # 00508ead
    jle.d8 L_00508eef                            # 00508eaf
    # block 0x00508eb1: entered by fall-through of jle at 0x00508eaf, 1 instruction(s), falls into the block at 0x00508eb5
    mov edi, dword ptr [esp + stk_28]            # 00508eb1
L_00508eb5:
    # block 0x00508eb5: entered by jl at 0x00508ee9, 8 instruction(s), calls FUN_0050be60, ends with jl to 0x00508fd3 (forward)
    push 0x8                                     # 00508eb5
    push ebx                                     # 00508eb7
    call FUN_0050be60                            # 00508eb8
    add esp, 0x8                                 # 00508ebd
    dec eax                                      # 00508ec0
    cmp eax, -0x1                                # 00508ec1
    mov dword ptr [edi], eax                     # 00508ec4
    jl.d32 L_00508fd3                            # 00508ec6
    # block 0x00508ecc: entered by fall-through of jl at 0x00508ec6, 3 instruction(s), ends with jge to 0x00508fd3 (forward)
    mov ecx, dword ptr [esp + stk_18]            # 00508ecc
    cmp eax, dword ptr [ecx + field_18]          # 00508ed0
    jge.d32 L_00508fd3                           # 00508ed3
    # block 0x00508ed9: entered by fall-through of jge at 0x00508ed3, 7 instruction(s), ends with jl to 0x00508eb5 (backward)
    mov ecx, dword ptr [esi - field_minus_40]    # 00508ed9
    mov edx, 0x1                                 # 00508edc
    shl edx, cl                                  # 00508ee1
    inc ebp                                      # 00508ee3
    add edi, 0x4                                 # 00508ee4
    {load} cmp ebp, edx                          # 00508ee7
    jl.d8 L_00508eb5                             # 00508ee9
    # block 0x00508eeb: entered by fall-through of jl at 0x00508ee9, 1 instruction(s), falls into the block at 0x00508eef
    mov edi, dword ptr [esp + stk_1c]            # 00508eeb
L_00508eef:
    # block 0x00508eef: entered by jle at 0x00508eaf, 10 instruction(s), ends with jl to 0x00508e59 (backward)
    mov eax, dword ptr [esp + stk_24]            # 00508eef
    mov edx, dword ptr [esp + stk_28]            # 00508ef3
    mov ebp, dword ptr [esp + stk_14]            # 00508ef7
    inc eax                                      # 00508efb
    add esi, 0x4                                 # 00508efc
    add edx, 0x20                                # 00508eff
    {load} cmp eax, edi                          # 00508f02
    mov dword ptr [esp + stk_24], eax            # 00508f04
    mov dword ptr [esp + stk_28], edx            # 00508f08
    jl.d32 L_00508e59                            # 00508f0c
L_00508f12:
    # block 0x00508f12: entered by jle at 0x00508e43; fall-through of jl at 0x00508f0c, 15 instruction(s), calls FUN_0050be60, ends with jle to 0x00508fae (forward)
    push 0x2                                     # 00508f12
    push ebx                                     # 00508f14
    call FUN_0050be60                            # 00508f15
    inc eax                                      # 00508f1a
    push 0x4                                     # 00508f1b
    push ebx                                     # 00508f1d
    mov dword ptr [ebp + field_340], eax         # 00508f1e
    call FUN_0050be60                            # 00508f24
    mov dword ptr [esp + stk_24], eax            # 00508f29
    {disp8} mov eax, dword ptr [ebp]             # 00508f2d
    add esp, 0x10                                # 00508f30
    {load} xor edi, edi                          # 00508f33
    test eax, eax                                # 00508f35
    mov dword ptr [esp + stk_24], edi            # 00508f37
    jle.d8 L_00508fae                            # 00508f3b
    # block 0x00508f3d: entered by fall-through of jle at 0x00508f3b, 2 instruction(s), falls into the block at 0x00508f44
    lea eax, [ebp + field_4]                     # 00508f3d
    mov dword ptr [esp + stk_28], eax            # 00508f40
L_00508f44:
    # block 0x00508f44: entered by jl at 0x00508fac, 7 instruction(s), ends with jge to 0x00508f93 (forward)
    mov ecx, dword ptr [esp + stk_28]            # 00508f44
    mov eax, dword ptr [esp + stk_10]            # 00508f48
    mov edx, dword ptr [ecx]                     # 00508f4c
    add eax, dword ptr [ebp + 4*edx + field_80]  # 00508f4e
    {load} cmp edi, eax                          # 00508f55
    mov dword ptr [esp + stk_10], eax            # 00508f57
    jge.d8 L_00508f93                            # 00508f5b
    # block 0x00508f5d: entered by fall-through of jge at 0x00508f5b, 1 instruction(s), falls into the block at 0x00508f64
    lea esi, [ebp + 4*edi + field_34c]           # 00508f5d
L_00508f64:
    # block 0x00508f64: entered by jl at 0x00508f91, 8 instruction(s), calls FUN_0050be60, ends with jl to 0x00508fd7 (forward)
    mov eax, dword ptr [esp + stk_14]            # 00508f64
    push eax                                     # 00508f68
    push ebx                                     # 00508f69
    call FUN_0050be60                            # 00508f6a
    add esp, 0x8                                 # 00508f6f
    mov dword ptr [esi], eax                     # 00508f72
    test eax, eax                                # 00508f74
    jl.d8 L_00508fd7                             # 00508f76
    # block 0x00508f78: entered by fall-through of jl at 0x00508f76, 5 instruction(s), ends with jge to 0x00508fd7 (forward)
    mov ecx, dword ptr [esp + stk_14]            # 00508f78
    mov edx, 0x1                                 # 00508f7c
    shl edx, cl                                  # 00508f81
    {load} cmp eax, edx                          # 00508f83
    jge.d8 L_00508fd7                            # 00508f85
    # block 0x00508f87: entered by fall-through of jge at 0x00508f85, 5 instruction(s), ends with jl to 0x00508f64 (backward)
    mov eax, dword ptr [esp + stk_10]            # 00508f87
    inc edi                                      # 00508f8b
    add esi, 0x4                                 # 00508f8c
    {load} cmp edi, eax                          # 00508f8f
    jl.d8 L_00508f64                             # 00508f91
L_00508f93:
    # block 0x00508f93: entered by jge at 0x00508f5b; fall-through of jl at 0x00508f91, 9 instruction(s), ends with jl to 0x00508f44 (backward)
    mov eax, dword ptr [esp + stk_24]            # 00508f93
    mov edx, dword ptr [esp + stk_28]            # 00508f97
    {disp8} mov ecx, dword ptr [ebp]             # 00508f9b
    inc eax                                      # 00508f9e
    add edx, 0x4                                 # 00508f9f
    {load} cmp eax, ecx                          # 00508fa2
    mov dword ptr [esp + stk_24], eax            # 00508fa4
    mov dword ptr [esp + stk_28], edx            # 00508fa8
    jl.d8 L_00508f44                             # 00508fac
L_00508fae:
    # block 0x00508fae: entered by jle at 0x00508f3b; fall-through of jl at 0x00508fac, 12 instruction(s), ends with ret
    mov ecx, dword ptr [esp + stk_14]            # 00508fae
    mov eax, 0x1                                 # 00508fb2
    shl eax, cl                                  # 00508fb7
    pop edi                                      # 00508fb9
    mov dword ptr [ebp + field_344], 0x0         # 00508fba
    pop esi                                      # 00508fc4
    mov dword ptr [ebp + field_348], eax         # 00508fc5
    {load} mov eax, ebp                          # 00508fcb
    pop ebp                                      # 00508fcd
    pop ebx                                      # 00508fce
    add esp, 0x10                                # 00508fcf
    ret                                          # 00508fd2
L_00508fd3:
    # block 0x00508fd3: entered by jl at 0x00508ec6; jge at 0x00508ed3, 1 instruction(s), falls into the block at 0x00508fd7
    mov ebp, dword ptr [esp + stk_14]            # 00508fd3
L_00508fd7:
    # block 0x00508fd7: entered by jl at 0x00508e75; jl at 0x00508e8e; jge at 0x00508e9b; jl at 0x00508f76; jge at 0x00508f85, 10 instruction(s), calls FUN_00508bc0, ends with ret
    push ebp                                     # 00508fd7
    call FUN_00508bc0                            # 00508fd8
    add esp, 0x4                                 # 00508fdd
    {load} xor eax, eax                          # 00508fe0
    pop edi                                      # 00508fe2
    pop esi                                      # 00508fe3
    pop ebp                                      # 00508fe4
    pop ebx                                      # 00508fe5
    add esp, 0x10                                # 00508fe6
    ret                                          # 00508fe9

# --- data items (not part of the function) -------------------------
.org 0x00508fea - 0x401000
PAD_00508fea:  # 6 byte(s) of nop padding
    .fill 6, 1, 0x90

