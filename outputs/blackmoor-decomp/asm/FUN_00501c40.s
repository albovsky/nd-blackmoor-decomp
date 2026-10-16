# FUN_00501c40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00501c40
# extent:       0x00501c40-0x00501e8f (591 code bytes)
# span:         0x00501c40-0x00501e90 (code 591, tables 0, padding 1)
# sha256:       2fb3e612ec439673a8d9ae9ae78d5d3f6ef36e51670e8b5162b830815e88ed8d
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00501c40
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4; [ecx + n] field_1f4, field_1fc, field_200; [edx + n] field_204; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_30, stk_34
# callees:      calls FUN_0050e19e, FUN_00501e90
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 186 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ arg_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ arg_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34
.equ field_1f4, 0x1f4  # offset +0x1f4
.equ field_1fc, 0x1fc  # offset +0x1fc
.equ field_200, 0x200  # offset +0x200
.equ field_204, 0x204  # offset +0x204

# --- external targets -----------------------------------------------
.set FUN_00501e90, .text + (0x00501e90 - 0x401000)
.set FUN_0050e19e, .text + (0x0050e19e - 0x401000)

.org 0x00501c40 - 0x401000
.globl FUN_00501c40
FUN_00501c40:
    # block 0x00501c40: entry, 20 instruction(s), ends with jle to 0x00501c80 (forward)
    push ebp                                     # 00501c40
    {load} mov ebp, esp                          # 00501c41
    and esp, -0x8                                # 00501c43
    sub esp, 0x2c                                # 00501c46
    mov eax, dword ptr [ebp + arg_8]             # 00501c49
    push ebx                                     # 00501c4c
    push esi                                     # 00501c4d
    push edi                                     # 00501c4e
    mov ecx, dword ptr [eax + field_4]           # 00501c4f
    mov edi, dword ptr [eax]                     # 00501c52
    {load} xor edx, edx                          # 00501c54
    mov dword ptr [esp + stk_30], edi            # 00501c56
    mov eax, dword ptr [ecx + field_1fc]         # 00501c5a
    mov ebx, dword ptr [ecx + field_200]         # 00501c60
    {load} cmp eax, edi                          # 00501c66
    mov dword ptr [esp + stk_1c], edx            # 00501c68
    mov dword ptr [esp + stk_34], ecx            # 00501c6c
    mov dword ptr [esp + stk_10], ebx            # 00501c70
    mov dword ptr [esp + stk_20], eax            # 00501c74
    jle.d8 L_00501c80                            # 00501c78
    # block 0x00501c7a: entered by fall-through of jle at 0x00501c78, 2 instruction(s), falls into the block at 0x00501c80
    mov dword ptr [esp + stk_20], edi            # 00501c7a
    {load} mov eax, edi                          # 00501c7e
L_00501c80:
    # block 0x00501c80: entered by jle at 0x00501c78, 3 instruction(s), ends with je to 0x00501e17 (forward)
    mov esi, dword ptr [ecx + field_1f4]         # 00501c80
    test esi, esi                                # 00501c86
    je.d32 L_00501e17                            # 00501c88
    # block 0x00501c8e: entered by fall-through of je at 0x00501c88, 2 instruction(s), ends with jle to 0x00501cd3 (forward)
    test eax, eax                                # 00501c8e
    jle.d8 L_00501cd3                            # 00501c90
    # block 0x00501c92: entered by fall-through of jle at 0x00501c90, 7 instruction(s), ends with forward jump to 0x00501cac
    mov esi, dword ptr [ebp + arg_10]            # 00501c92
    mov ecx, dword ptr [ebp + arg_c]             # 00501c95
    {load} sub ecx, esi                          # 00501c98
    mov dword ptr [esp + stk_28], eax            # 00501c9a
    mov dword ptr [esp + stk_2c], ecx            # 00501c9e
    mov dword ptr [esp + stk_1c], eax            # 00501ca2
    jmp.d8 L_00501cac                            # 00501ca6
L_00501ca8:
    # block 0x00501ca8: entered by jne at 0x00501cd1, 1 instruction(s), falls into the block at 0x00501cac
    mov ecx, dword ptr [esp + stk_2c]            # 00501ca8
L_00501cac:
    # block 0x00501cac: entered by jmp at 0x00501ca6, 12 instruction(s), calls FUN_0050e19e, ends with jne to 0x00501ca8 (backward)
    fld dword ptr [ecx + esi]                    # 00501cac
    fadd dword ptr [0x52cd14]                    # 00501caf
    sub esp, 0x8                                 # 00501cb5
    fstp qword ptr [esp]                         # 00501cb8
    call FUN_0050e19e                            # 00501cbb
    fstp dword ptr [esi]                         # 00501cc0
    mov eax, dword ptr [esp + stk_30]            # 00501cc2
    add esp, 0x8                                 # 00501cc6
    add esi, 0x4                                 # 00501cc9
    dec eax                                      # 00501ccc
    mov dword ptr [esp + stk_28], eax            # 00501ccd
    jne.d8 L_00501ca8                            # 00501cd1
L_00501cd3:
    # block 0x00501cd3: entered by jle at 0x00501c90; fall-through of jne at 0x00501cd1, 4 instruction(s), ends with jg to 0x00501e17 (forward)
    mov edx, dword ptr [esp + stk_1c]            # 00501cd3
    lea eax, [ebx + edx]                         # 00501cd7
    {load} cmp eax, edi                          # 00501cda
    jg.d32 L_00501e17                            # 00501cdc
    # block 0x00501ce2: entered by fall-through of jg at 0x00501cdc, 3 instruction(s), falls into the block at 0x00501cef
    {load} mov esi, eax                          # 00501ce2
    lea edi, [4*edx]                             # 00501ce4
    mov dword ptr [esp + stk_2c], esi            # 00501ceb
L_00501cef:
    # block 0x00501cef: entered by jle at 0x00501e0f, 4 instruction(s), ends with jge to 0x00501d1b (forward)
    fld dword ptr [0x52db78]                     # 00501cef
    {load} cmp edx, esi                          # 00501cf5
    fst dword ptr [esp + stk_14]                 # 00501cf7
    jge.d8 L_00501d1b                            # 00501cfb
    # block 0x00501cfd: entered by fall-through of jge at 0x00501cfb, 4 instruction(s), falls into the block at 0x00501d07
    mov eax, dword ptr [ebp + arg_c]             # 00501cfd
    lea ecx, [edi + eax]                         # 00501d00
    {load} mov eax, esi                          # 00501d03
    {load} sub eax, edx                          # 00501d05
L_00501d07:
    # block 0x00501d07: entered by jne at 0x00501d15, 8 instruction(s), ends with jne to 0x00501d07 (backward)
    fld dword ptr [ecx]                          # 00501d07
    fld st(0)                                    # 00501d09
    fmul st, st(1)                               # 00501d0b
    add ecx, 0x4                                 # 00501d0d
    dec eax                                      # 00501d10
    faddp st(2), st                              # 00501d11
    fstp st(0)                                   # 00501d13
    jne.d8 L_00501d07                            # 00501d15
    # block 0x00501d17: entered by fall-through of jne at 0x00501d15, 1 instruction(s), falls into the block at 0x00501d1b
    fst dword ptr [esp + stk_14]                 # 00501d17
L_00501d1b:
    # block 0x00501d1b: entered by jge at 0x00501cfb, 4 instruction(s), ends with jle to 0x00501e88 (forward)
    {load} xor eax, eax                          # 00501d1b
    {load} cmp ebx, eax                          # 00501d1d
    mov dword ptr [esp + stk_18], eax            # 00501d1f
    jle.d32 L_00501e88                           # 00501d23
    # block 0x00501d29: entered by fall-through of jle at 0x00501d23, 3 instruction(s), falls into the block at 0x00501d38
    mov ecx, dword ptr [esp + stk_20]            # 00501d29
    mov dword ptr [esp + stk_28], eax            # 00501d2d
    lea ebx, [4*ecx]                             # 00501d31
L_00501d38:
    # block 0x00501d38: entered by jl at 0x00501de0, 13 instruction(s), ends with jne to 0x00501d90 (forward)
    mov eax, dword ptr [esp + stk_28]            # 00501d38
    mov edx, dword ptr [ebp + arg_14]            # 00501d3c
    mov ecx, dword ptr [ebp + arg_c]             # 00501d3f
    {load} sub eax, ebx                          # 00501d42
    {load} add eax, edi                          # 00501d44
    mov esi, dword ptr [eax + edx]               # 00501d46
    fld dword ptr [ecx + 4*esi]                  # 00501d49
    fst dword ptr [esp + stk_24]                 # 00501d4c
    fmul dword ptr [esp + stk_24]                # 00501d50
    fcomp dword ptr [0x52e5d0]                   # 00501d54
    fnstsw ax                                    # 00501d5a
    test ah, 0x1                                 # 00501d5c
    jne.d8 L_00501d90                            # 00501d5f
    # block 0x00501d61: entered by fall-through of jne at 0x00501d5f, 15 instruction(s), calls FUN_0050e19e, ends with forward jump to 0x00501dc2
    fstp st(0)                                   # 00501d61
    fld dword ptr [ecx + 4*esi]                  # 00501d63
    fadd dword ptr [0x52cd14]                    # 00501d66
    sub esp, 0x8                                 # 00501d6c
    fstp qword ptr [esp]                         # 00501d6f
    call FUN_0050e19e                            # 00501d72
    mov eax, dword ptr [ebp + arg_10]            # 00501d77
    mov ecx, dword ptr [ebp + arg_c]             # 00501d7a
    add esp, 0x8                                 # 00501d7d
    fstp dword ptr [eax + 4*esi]                 # 00501d80
    fld dword ptr [ecx + 4*esi]                  # 00501d83
    fld st(0)                                    # 00501d86
    fmulp st(1), st                              # 00501d88
    fsubr dword ptr [esp + stk_14]               # 00501d8a
    jmp.d8 L_00501dc2                            # 00501d8e
L_00501d90:
    # block 0x00501d90: entered by jne at 0x00501d5f, 5 instruction(s), ends with jne to 0x00501e4e (forward)
    mov edx, dword ptr [esp + stk_34]            # 00501d90
    fcomp qword ptr [edx + field_204]            # 00501d94
    fnstsw ax                                    # 00501d9a
    test ah, 0x1                                 # 00501d9c
    jne.d32 L_00501e4e                           # 00501d9f
    # block 0x00501da5: entered by fall-through of jne at 0x00501d9f, 8 instruction(s), calls FUN_00501e90, falls into the block at 0x00501dc2
    mov eax, dword ptr [esp + stk_24]            # 00501da5
    push eax                                     # 00501da9
    call FUN_00501e90                            # 00501daa
    mov ecx, dword ptr [ebp + arg_10]            # 00501daf
    add esp, 0x4                                 # 00501db2
    fstp dword ptr [ecx + 4*esi]                 # 00501db5
    fld dword ptr [esp + stk_14]                 # 00501db8
    fsub qword ptr [0x52c598]                    # 00501dbc
L_00501dc2:
    # block 0x00501dc2: entered by jmp at 0x00501d8e, 10 instruction(s), ends with jl to 0x00501d38 (backward)
    mov eax, dword ptr [esp + stk_18]            # 00501dc2
    mov edx, dword ptr [esp + stk_28]            # 00501dc6
    mov ecx, dword ptr [esp + stk_10]            # 00501dca
    inc eax                                      # 00501dce
    fst dword ptr [esp + stk_14]                 # 00501dcf
    add edx, 0x4                                 # 00501dd3
    {load} cmp eax, ecx                          # 00501dd6
    mov dword ptr [esp + stk_18], eax            # 00501dd8
    mov dword ptr [esp + stk_28], edx            # 00501ddc
    jl.d32 L_00501d38                            # 00501de0
    # block 0x00501de6: entered by fall-through of jl at 0x00501de0, 1 instruction(s), falls into the block at 0x00501de8
    fstp st(0)                                   # 00501de6
L_00501de8:
    # block 0x00501de8: entered by jge at 0x00501e58; jmp at 0x00501e83, 1 instruction(s), falls into the block at 0x00501dec
    mov ebx, dword ptr [esp + stk_10]            # 00501de8
L_00501dec:
    # block 0x00501dec: entered by jmp at 0x00501e8a, 11 instruction(s), ends with jle to 0x00501cef (backward)
    mov esi, dword ptr [esp + stk_2c]            # 00501dec
    mov edx, dword ptr [esp + stk_1c]            # 00501df0
    lea eax, [4*ebx]                             # 00501df4
    {load} add esi, ebx                          # 00501dfb
    {load} add edi, eax                          # 00501dfd
    mov eax, dword ptr [esp + stk_30]            # 00501dff
    {load} add edx, ebx                          # 00501e03
    {load} cmp esi, eax                          # 00501e05
    mov dword ptr [esp + stk_1c], edx            # 00501e07
    mov dword ptr [esp + stk_2c], esi            # 00501e0b
    jle.d32 L_00501cef                           # 00501e0f
    # block 0x00501e15: entered by fall-through of jle at 0x00501e0f, 1 instruction(s), falls into the block at 0x00501e17
    {load} mov edi, eax                          # 00501e15
L_00501e17:
    # block 0x00501e17: entered by je at 0x00501c88; jg at 0x00501cdc, 2 instruction(s), ends with jge to 0x00501e47 (forward)
    {load} cmp edx, edi                          # 00501e17
    jge.d8 L_00501e47                            # 00501e19
    # block 0x00501e1b: entered by fall-through of jge at 0x00501e19, 5 instruction(s), falls into the block at 0x00501e28
    mov eax, dword ptr [ebp + arg_10]            # 00501e1b
    mov ebx, dword ptr [ebp + arg_c]             # 00501e1e
    {load} sub ebx, eax                          # 00501e21
    {load} sub edi, edx                          # 00501e23
    lea esi, [eax + 4*edx]                       # 00501e25
L_00501e28:
    # block 0x00501e28: entered by jne at 0x00501e45, 10 instruction(s), calls FUN_0050e19e, ends with jne to 0x00501e28 (backward)
    fld dword ptr [esi + ebx]                    # 00501e28
    fadd dword ptr [0x52cd14]                    # 00501e2b
    sub esp, 0x8                                 # 00501e31
    fstp qword ptr [esp]                         # 00501e34
    call FUN_0050e19e                            # 00501e37
    fstp dword ptr [esi]                         # 00501e3c
    add esp, 0x8                                 # 00501e3e
    add esi, 0x4                                 # 00501e41
    dec edi                                      # 00501e44
    jne.d8 L_00501e28                            # 00501e45
L_00501e47:
    # block 0x00501e47: entered by jge at 0x00501e19; fall-through of jne at 0x00501e45, 6 instruction(s), ends with ret
    pop edi                                      # 00501e47
    pop esi                                      # 00501e48
    pop ebx                                      # 00501e49
    {load} mov esp, ebp                          # 00501e4a
    pop ebp                                      # 00501e4c
    ret                                          # 00501e4d
L_00501e4e:
    # block 0x00501e4e: entered by jne at 0x00501d9f, 4 instruction(s), ends with jge to 0x00501de8 (backward)
    mov eax, dword ptr [esp + stk_18]            # 00501e4e
    mov ecx, dword ptr [esp + stk_10]            # 00501e52
    {load} cmp eax, ecx                          # 00501e56
    jge.d8 L_00501de8                            # 00501e58
    # block 0x00501e5a: entered by fall-through of jge at 0x00501e58, 3 instruction(s), falls into the block at 0x00501e67
    mov edx, dword ptr [esp + stk_10]            # 00501e5a
    lea ecx, [4*eax]                             # 00501e5e
    {load} sub edx, eax                          # 00501e65
L_00501e67:
    # block 0x00501e67: entered by jne at 0x00501e81, 10 instruction(s), ends with jne to 0x00501e67 (backward)
    mov esi, dword ptr [ebp + arg_14]            # 00501e67
    {load} mov eax, ecx                          # 00501e6a
    {load} sub eax, ebx                          # 00501e6c
    add ecx, 0x4                                 # 00501e6e
    {load} add eax, edi                          # 00501e71
    dec edx                                      # 00501e73
    mov eax, dword ptr [eax + esi]               # 00501e74
    mov esi, dword ptr [ebp + arg_10]            # 00501e77
    mov dword ptr [esi + 4*eax], 0x0             # 00501e7a
    jne.d8 L_00501e67                            # 00501e81
    # block 0x00501e83: entered by fall-through of jne at 0x00501e81, 1 instruction(s), ends with backward jump to 0x00501de8
    jmp.d32 L_00501de8                           # 00501e83
L_00501e88:
    # block 0x00501e88: entered by jle at 0x00501d23, 2 instruction(s), ends with backward jump to 0x00501dec
    fstp st(0)                                   # 00501e88
    jmp.d32 L_00501dec                           # 00501e8a

# --- data items (not part of the function) -------------------------
.org 0x00501e8f - 0x401000
PAD_00501e8f:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

