# FUN_00503de0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00503de0
# extent:       0x00503de0-0x00503fa0 (448 code bytes)
# span:         0x00503de0-0x00503fa0 (code 448, tables 0, padding 0)
# sha256:       8713d0cfac5b63bb789c696cf22c17c48c01c746b684c702415f38a133ef4434
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00503de0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_minus_4; [ebp + n] field_minus_1; [ecx + n] field_minus_4; [edi + n] field_minus_4; [edx + n] field_minus_4; [esi + n] field_minus_4; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_28, stk_2c, stk_30, stk_34, stk_38
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 151 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_minus_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38

# --- external targets -----------------------------------------------

.org 0x00503de0 - 0x401000
.globl FUN_00503de0
FUN_00503de0:
    # block 0x00503de0: entry, 14 instruction(s), ends with jle to 0x00503e66 (forward)
    sub esp, 0x14                                # 00503de0
    push ebx                                     # 00503de3
    push ebp                                     # 00503de4
    mov ebp, dword ptr [esp + stk_20]            # 00503de5
    push esi                                     # 00503de9
    push edi                                     # 00503dea
    mov edi, dword ptr [esp + stk_2c]            # 00503deb
    {load} mov esi, ebp                          # 00503def
    mov edx, dword ptr [esp + stk_30]            # 00503df1
    imul esi, edi                                # 00503df5
    test edi, edi                                # 00503df8
    mov dword ptr [esp + stk_20], esi            # 00503dfa
    {disp8} lea ebx, [ebp + ebp]                 # 00503dfe
    jle.d8 L_00503e66                            # 00503e02
    # block 0x00503e04: entered by fall-through of jle at 0x00503e02, 8 instruction(s), falls into the block at 0x00503e21
    mov edi, dword ptr [esp + stk_34]            # 00503e04
    {load} mov eax, edx                          # 00503e08
    mov dword ptr [esp + stk_14], edi            # 00503e0a
    lea ecx, [edx + 4*esi]                       # 00503e0e
    lea edi, [edi + 4*ebx - field_minus_4]       # 00503e11
    mov dword ptr [esp + stk_28], edi            # 00503e15
    mov edi, dword ptr [esp + stk_2c]            # 00503e19
    mov dword ptr [esp + stk_10], edi            # 00503e1d
L_00503e21:
    # block 0x00503e21: entered by jne at 0x00503e60, 21 instruction(s), ends with jne to 0x00503e21 (backward)
    fld dword ptr [eax]                          # 00503e21
    fadd dword ptr [ecx]                         # 00503e23
    mov edi, dword ptr [esp + stk_14]            # 00503e25
    mov ebx, dword ptr [esp + stk_28]            # 00503e29
    fstp dword ptr [edi]                         # 00503e2d
    fld dword ptr [eax]                          # 00503e2f
    fsub dword ptr [ecx]                         # 00503e31
    fstp dword ptr [ebx]                         # 00503e33
    lea ebx, [8*ebp]                             # 00503e35
    {load} add edi, ebx                          # 00503e3c
    mov dword ptr [esp + stk_14], edi            # 00503e3e
    lea edi, [4*ebp]                             # 00503e42
    {load} add eax, edi                          # 00503e49
    {load} add ecx, edi                          # 00503e4b
    mov edi, dword ptr [esp + stk_28]            # 00503e4d
    {load} add edi, ebx                          # 00503e51
    mov dword ptr [esp + stk_28], edi            # 00503e53
    mov edi, dword ptr [esp + stk_10]            # 00503e57
    dec edi                                      # 00503e5b
    mov dword ptr [esp + stk_10], edi            # 00503e5c
    jne.d8 L_00503e21                            # 00503e60
    # block 0x00503e62: entered by fall-through of jne at 0x00503e60, 1 instruction(s), falls into the block at 0x00503e66
    mov edi, dword ptr [esp + stk_2c]            # 00503e62
L_00503e66:
    # block 0x00503e66: entered by jle at 0x00503e02, 2 instruction(s), ends with jl to 0x00503f98 (forward)
    cmp ebp, 0x2                                 # 00503e66
    jl.d32 L_00503f98                            # 00503e69
    # block 0x00503e6f: entered by fall-through of jl at 0x00503e69, 1 instruction(s), ends with je to 0x00503f5f (forward)
    je.d32 L_00503f5f                            # 00503e6f
    # block 0x00503e75: entered by fall-through of je at 0x00503e6f, 2 instruction(s), ends with jle to 0x00503f4c (forward)
    test edi, edi                                # 00503e75
    jle.d32 L_00503f4c                           # 00503e77
    # block 0x00503e7d: entered by fall-through of jle at 0x00503e77, 8 instruction(s), falls into the block at 0x00503e9b
    mov eax, dword ptr [esp + stk_34]            # 00503e7d
    lea ecx, [edx + 4*esi]                       # 00503e81
    mov dword ptr [esp + stk_14], eax            # 00503e84
    mov dword ptr [esp + stk_28], edx            # 00503e88
    lea esi, [eax + 8*ebp]                       # 00503e8c
    mov dword ptr [esp + stk_10], ecx            # 00503e8f
    mov dword ptr [esp + stk_18], esi            # 00503e93
    mov dword ptr [esp + stk_1c], edi            # 00503e97
L_00503e9b:
    # block 0x00503e9b: entered by jne at 0x00503f46, 2 instruction(s), ends with jle to 0x00503f07 (forward)
    cmp ebp, 0x2                                 # 00503e9b
    jle.d8 L_00503f07                            # 00503e9e
    # block 0x00503ea0: entered by fall-through of jle at 0x00503e9e, 7 instruction(s), falls into the block at 0x00503eb8
    mov edx, dword ptr [esp + stk_38]            # 00503ea0
    mov ecx, dword ptr [esp + stk_28]            # 00503ea4
    mov edi, dword ptr [esp + stk_14]            # 00503ea8
    mov eax, dword ptr [esp + stk_10]            # 00503eac
    lea ebx, [ebp - field_minus_1]               # 00503eb0
    add edx, 0x4                                 # 00503eb3
    shr ebx                                      # 00503eb6
L_00503eb8:
    # block 0x00503eb8: entered by jne at 0x00503efd, 29 instruction(s), ends with jne to 0x00503eb8 (backward)
    fld dword ptr [edx - field_minus_4]          # 00503eb8
    fmul dword ptr [eax + field_4]               # 00503ebb
    fld dword ptr [eax + field_8]                # 00503ebe
    fmul dword ptr [edx]                         # 00503ec1
    add eax, 0x8                                 # 00503ec3
    add ecx, 0x8                                 # 00503ec6
    add edi, 0x8                                 # 00503ec9
    sub esi, 0x8                                 # 00503ecc
    faddp st(1), st                              # 00503ecf
    fld dword ptr [edx - field_minus_4]          # 00503ed1
    fmul dword ptr [eax]                         # 00503ed4
    fld dword ptr [edx]                          # 00503ed6
    fmul dword ptr [eax - field_minus_4]         # 00503ed8
    add edx, 0x8                                 # 00503edb
    dec ebx                                      # 00503ede
    fsubp st(1), st                              # 00503edf
    fld st(0)                                    # 00503ee1
    fadd dword ptr [ecx]                         # 00503ee3
    fstp dword ptr [edi]                         # 00503ee5
    fsub dword ptr [ecx]                         # 00503ee7
    fstp dword ptr [esi]                         # 00503ee9
    fld st(0)                                    # 00503eeb
    fadd dword ptr [ecx - field_minus_4]         # 00503eed
    fstp dword ptr [edi - field_minus_4]         # 00503ef0
    fld dword ptr [ecx - field_minus_4]          # 00503ef3
    fsub st, st(1)                               # 00503ef6
    fstp dword ptr [esi - field_minus_4]         # 00503ef8
    fstp st(0)                                   # 00503efb
    jne.d8 L_00503eb8                            # 00503efd
    # block 0x00503eff: entered by fall-through of jne at 0x00503efd, 2 instruction(s), falls into the block at 0x00503f07
    mov edi, dword ptr [esp + stk_2c]            # 00503eff
    mov edx, dword ptr [esp + stk_30]            # 00503f03
L_00503f07:
    # block 0x00503f07: entered by jle at 0x00503e9e, 18 instruction(s), ends with jne to 0x00503e9b (backward)
    mov ebx, dword ptr [esp + stk_28]            # 00503f07
    mov esi, dword ptr [esp + stk_18]            # 00503f0b
    lea ecx, [4*ebp]                             # 00503f0f
    lea eax, [8*ebp]                             # 00503f16
    {load} add ebx, ecx                          # 00503f1d
    {load} add esi, eax                          # 00503f1f
    mov dword ptr [esp + stk_28], ebx            # 00503f21
    mov ebx, dword ptr [esp + stk_10]            # 00503f25
    {load} add ebx, ecx                          # 00503f29
    mov ecx, dword ptr [esp + stk_14]            # 00503f2b
    {load} add ecx, eax                          # 00503f2f
    mov eax, dword ptr [esp + stk_1c]            # 00503f31
    dec eax                                      # 00503f35
    mov dword ptr [esp + stk_18], esi            # 00503f36
    mov dword ptr [esp + stk_10], ebx            # 00503f3a
    mov dword ptr [esp + stk_14], ecx            # 00503f3e
    mov dword ptr [esp + stk_1c], eax            # 00503f42
    jne.d32 L_00503e9b                           # 00503f46
L_00503f4c:
    # block 0x00503f4c: entered by jle at 0x00503e77; fall-through of jne at 0x00503f46, 3 instruction(s), ends with jns to 0x00503f5a (forward)
    {load} mov eax, ebp                          # 00503f4c
    and eax, 0x80000001                          # 00503f4e
    jns.d8 L_00503f5a                            # 00503f53
    # block 0x00503f55: entered by fall-through of jns at 0x00503f53, 3 instruction(s), falls into the block at 0x00503f5a
    dec eax                                      # 00503f55
    or eax, -0x2                                 # 00503f56
    inc eax                                      # 00503f59
L_00503f5a:
    # block 0x00503f5a: entered by jns at 0x00503f53, 2 instruction(s), ends with je to 0x00503f98 (forward)
    cmp eax, 0x1                                 # 00503f5a
    je.d8 L_00503f98                             # 00503f5d
L_00503f5f:
    # block 0x00503f5f: entered by je at 0x00503e6f; fall-through of je at 0x00503f5d, 6 instruction(s), ends with jle to 0x00503f98 (forward)
    mov ebx, dword ptr [esp + stk_20]            # 00503f5f
    lea esi, [ebp - field_minus_1]               # 00503f63
    {load} mov ecx, esi                          # 00503f66
    {load} add esi, ebx                          # 00503f68
    test edi, edi                                # 00503f6a
    jle.d8 L_00503f98                            # 00503f6c
    # block 0x00503f6e: entered by fall-through of jle at 0x00503f6c, 6 instruction(s), falls into the block at 0x00503f84
    mov eax, dword ptr [esp + stk_34]            # 00503f6e
    lea ebx, [8*ebp]                             # 00503f72
    shl ebp, 0x2                                 # 00503f79
    lea ecx, [edx + 4*ecx]                       # 00503f7c
    {load} add eax, ebp                          # 00503f7f
    lea edx, [edx + 4*esi]                       # 00503f81
L_00503f84:
    # block 0x00503f84: entered by jne at 0x00503f96, 10 instruction(s), ends with jne to 0x00503f84 (backward)
    fld dword ptr [edx]                          # 00503f84
    fchs                                         # 00503f86
    fstp dword ptr [eax]                         # 00503f88
    mov esi, dword ptr [ecx]                     # 00503f8a
    {load} add edx, ebp                          # 00503f8c
    mov dword ptr [eax - field_minus_4], esi     # 00503f8e
    {load} add eax, ebx                          # 00503f91
    {load} add ecx, ebp                          # 00503f93
    dec edi                                      # 00503f95
    jne.d8 L_00503f84                            # 00503f96
L_00503f98:
    # block 0x00503f98: entered by jl at 0x00503e69; je at 0x00503f5d; jle at 0x00503f6c; fall-through of jne at 0x00503f96, 6 instruction(s), ends with ret
    pop edi                                      # 00503f98
    pop esi                                      # 00503f99
    pop ebp                                      # 00503f9a
    pop ebx                                      # 00503f9b
    add esp, 0x14                                # 00503f9c
    ret                                          # 00503f9f

