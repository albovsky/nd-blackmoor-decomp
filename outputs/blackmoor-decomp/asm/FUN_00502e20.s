# FUN_00502e20
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00502e20
# extent:       0x00502e20-0x0050305e (574 code bytes)
# span:         0x00502e20-0x00503060 (code 574, tables 0, padding 2)
# sha256:       ed8f5f292931ba7d3b442a65d5f1cc4381d18279375af5738a8343bc736fbce3
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00502e20
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_4; [esi + n] field_4, field_8, field_c, field_10, field_14, field_18, field_1c, field_20, field_30; [esp + n] stk_8, stk_14, stk_18, stk_1c
# callees:      calls FUN_0050be60, FUN_0050ea90, FUN_005023e0, FUN_005025c0, FUN_00502820
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 218 instruction(s), 27 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_30, 0x30  # offset +0x30

# --- external targets -----------------------------------------------
.set FUN_005023e0, .text + (0x005023e0 - 0x401000)
.set FUN_005025c0, .text + (0x005025c0 - 0x401000)
.set FUN_00502820, .text + (0x00502820 - 0x401000)
.set FUN_0050be60, .text + (0x0050be60 - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)

.org 0x00502e20 - 0x401000
.globl FUN_00502e20
FUN_00502e20:
    # block 0x00502e20: entry, 17 instruction(s), calls FUN_0050be60, ends with jne to 0x00503046 (forward)
    push ebx                                     # 00502e20
    mov ebx, dword ptr [esp + stk_8]             # 00502e21
    push ebp                                     # 00502e25
    push esi                                     # 00502e26
    mov esi, dword ptr [esp + stk_14]            # 00502e27
    push edi                                     # 00502e2b
    mov ecx, 0xd                                 # 00502e2c
    {load} xor eax, eax                          # 00502e31
    {load} mov edi, esi                          # 00502e33
    push 0x18                                    # 00502e35
    rep stosd dword ptr es:[edi], eax            # 00502e37
    push ebx                                     # 00502e39
    mov dword ptr [esi + field_30], 0x1          # 00502e3a
    call FUN_0050be60                            # 00502e41
    add esp, 0x8                                 # 00502e46
    cmp eax, 0x564342                            # 00502e49
    jne.d32 L_00503046                           # 00502e4e
    # block 0x00502e54: entered by fall-through of jne at 0x00502e4e, 11 instruction(s), calls FUN_0050be60, ends with je to 0x00503046 (forward)
    push 0x10                                    # 00502e54
    push ebx                                     # 00502e56
    call FUN_0050be60                            # 00502e57
    push 0x18                                    # 00502e5c
    push ebx                                     # 00502e5e
    mov dword ptr [esi], eax                     # 00502e5f
    call FUN_0050be60                            # 00502e61
    add esp, 0x10                                # 00502e66
    cmp eax, -0x1                                # 00502e69
    mov dword ptr [esi + field_4], eax           # 00502e6c
    je.d32 L_00503046                            # 00502e6f
    # block 0x00502e75: entered by fall-through of je at 0x00502e6f, 6 instruction(s), calls FUN_0050be60, ends with je to 0x00502ef9 (forward)
    push 0x1                                     # 00502e75
    push ebx                                     # 00502e77
    call FUN_0050be60                            # 00502e78
    add esp, 0x8                                 # 00502e7d
    sub eax, 0x0                                 # 00502e80
    je.d8 L_00502ef9                             # 00502e83
    # block 0x00502e85: entered by fall-through of je at 0x00502e83, 2 instruction(s), ends with je to 0x00502e90 (forward)
    dec eax                                      # 00502e85
    je.d8 L_00502e90                             # 00502e86
    # block 0x00502e88: entered by fall-through of je at 0x00502e86, 6 instruction(s), ends with ret
    pop edi                                      # 00502e88
    pop esi                                      # 00502e89
    pop ebp                                      # 00502e8a
    or eax, -0x1                                 # 00502e8b
    pop ebx                                      # 00502e8e
    ret                                          # 00502e8f
L_00502e90:
    # block 0x00502e90: entered by je at 0x00502e86, 15 instruction(s), calls FUN_0050be60, FUN_0050ea90, ends with jle to 0x00502f8c (forward)
    push 0x5                                     # 00502e90
    push ebx                                     # 00502e92
    call FUN_0050be60                            # 00502e93
    {load} mov ebp, eax                          # 00502e98
    mov eax, dword ptr [esi + field_4]           # 00502e9a
    shl eax, 0x2                                 # 00502e9d
    push eax                                     # 00502ea0
    inc ebp                                      # 00502ea1
    call FUN_0050ea90                            # 00502ea2
    mov dword ptr [esi + field_8], eax           # 00502ea7
    mov eax, dword ptr [esi + field_4]           # 00502eaa
    add esp, 0xc                                 # 00502ead
    {load} xor edi, edi                          # 00502eb0
    test eax, eax                                # 00502eb2
    jle.d32 L_00502f8c                           # 00502eb4
L_00502eba:
    # block 0x00502eba: entered by jl at 0x00502ef2; fall-through of jle at 0x00502eb4, 9 instruction(s), calls FUN_005023e0, FUN_0050be60, ends with je to 0x00503046 (forward)
    {load} sub eax, edi                          # 00502eba
    push eax                                     # 00502ebc
    call FUN_005023e0                            # 00502ebd
    push eax                                     # 00502ec2
    push ebx                                     # 00502ec3
    call FUN_0050be60                            # 00502ec4
    add esp, 0xc                                 # 00502ec9
    cmp eax, -0x1                                # 00502ecc
    je.d32 L_00503046                            # 00502ecf
    # block 0x00502ed5: entered by fall-through of je at 0x00502ecf, 3 instruction(s), ends with jle to 0x00502eec (forward)
    {load} xor ecx, ecx                          # 00502ed5
    test eax, eax                                # 00502ed7
    jle.d8 L_00502eec                            # 00502ed9
L_00502edb:
    # block 0x00502edb: entered by jl at 0x00502eea; fall-through of jle at 0x00502ed9, 2 instruction(s), ends with jge to 0x00502eec (forward)
    cmp edi, dword ptr [esi + field_4]           # 00502edb
    jge.d8 L_00502eec                            # 00502ede
    # block 0x00502ee0: entered by fall-through of jge at 0x00502ede, 6 instruction(s), ends with jl to 0x00502edb (backward)
    mov edx, dword ptr [esi + field_8]           # 00502ee0
    inc ecx                                      # 00502ee3
    mov dword ptr [edx + 4*edi], ebp             # 00502ee4
    inc edi                                      # 00502ee7
    {load} cmp ecx, eax                          # 00502ee8
    jl.d8 L_00502edb                             # 00502eea
L_00502eec:
    # block 0x00502eec: entered by jle at 0x00502ed9; jge at 0x00502ede; fall-through of jl at 0x00502eea, 4 instruction(s), ends with jl to 0x00502eba (backward)
    mov eax, dword ptr [esi + field_4]           # 00502eec
    inc ebp                                      # 00502eef
    {load} cmp edi, eax                          # 00502ef0
    jl.d8 L_00502eba                             # 00502ef2
    # block 0x00502ef4: entered by fall-through of jl at 0x00502ef2, 1 instruction(s), ends with forward jump to 0x00502f8c
    jmp.d32 L_00502f8c                           # 00502ef4
L_00502ef9:
    # block 0x00502ef9: entered by je at 0x00502e83, 11 instruction(s), calls FUN_0050ea90, FUN_0050be60, ends with je to 0x00502f60 (forward)
    mov eax, dword ptr [esi + field_4]           # 00502ef9
    shl eax, 0x2                                 # 00502efc
    push eax                                     # 00502eff
    call FUN_0050ea90                            # 00502f00
    push 0x1                                     # 00502f05
    push ebx                                     # 00502f07
    mov dword ptr [esi + field_8], eax           # 00502f08
    call FUN_0050be60                            # 00502f0b
    add esp, 0xc                                 # 00502f10
    test eax, eax                                # 00502f13
    je.d8 L_00502f60                             # 00502f15
    # block 0x00502f17: entered by fall-through of je at 0x00502f15, 4 instruction(s), ends with jle to 0x00502f8c (forward)
    mov eax, dword ptr [esi + field_4]           # 00502f17
    {load} xor edi, edi                          # 00502f1a
    test eax, eax                                # 00502f1c
    jle.d8 L_00502f8c                            # 00502f1e
L_00502f20:
    # block 0x00502f20: entered by jl at 0x00502f5c; fall-through of jle at 0x00502f1e, 6 instruction(s), calls FUN_0050be60, ends with je to 0x00502f4c (forward)
    push 0x1                                     # 00502f20
    push ebx                                     # 00502f22
    call FUN_0050be60                            # 00502f23
    add esp, 0x8                                 # 00502f28
    test eax, eax                                # 00502f2b
    je.d8 L_00502f4c                             # 00502f2d
    # block 0x00502f2f: entered by fall-through of je at 0x00502f2d, 6 instruction(s), calls FUN_0050be60, ends with je to 0x00503046 (forward)
    push 0x5                                     # 00502f2f
    push ebx                                     # 00502f31
    call FUN_0050be60                            # 00502f32
    add esp, 0x8                                 # 00502f37
    cmp eax, -0x1                                # 00502f3a
    je.d32 L_00503046                            # 00502f3d
    # block 0x00502f43: entered by fall-through of je at 0x00502f3d, 4 instruction(s), ends with forward jump to 0x00502f56
    mov ecx, dword ptr [esi + field_8]           # 00502f43
    inc eax                                      # 00502f46
    mov dword ptr [ecx + 4*edi], eax             # 00502f47
    jmp.d8 L_00502f56                            # 00502f4a
L_00502f4c:
    # block 0x00502f4c: entered by je at 0x00502f2d, 2 instruction(s), falls into the block at 0x00502f56
    mov edx, dword ptr [esi + field_8]           # 00502f4c
    mov dword ptr [edx + 4*edi], 0x0             # 00502f4f
L_00502f56:
    # block 0x00502f56: entered by jmp at 0x00502f4a, 4 instruction(s), ends with jl to 0x00502f20 (backward)
    mov eax, dword ptr [esi + field_4]           # 00502f56
    inc edi                                      # 00502f59
    {load} cmp edi, eax                          # 00502f5a
    jl.d8 L_00502f20                             # 00502f5c
    # block 0x00502f5e: entered by fall-through of jl at 0x00502f5c, 1 instruction(s), ends with forward jump to 0x00502f8c
    jmp.d8 L_00502f8c                            # 00502f5e
L_00502f60:
    # block 0x00502f60: entered by je at 0x00502f15, 4 instruction(s), ends with jle to 0x00502f8c (forward)
    mov eax, dword ptr [esi + field_4]           # 00502f60
    {load} xor edi, edi                          # 00502f63
    test eax, eax                                # 00502f65
    jle.d8 L_00502f8c                            # 00502f67
L_00502f69:
    # block 0x00502f69: entered by jl at 0x00502f8a; fall-through of jle at 0x00502f67, 6 instruction(s), calls FUN_0050be60, ends with je to 0x00503046 (forward)
    push 0x5                                     # 00502f69
    push ebx                                     # 00502f6b
    call FUN_0050be60                            # 00502f6c
    add esp, 0x8                                 # 00502f71
    cmp eax, -0x1                                # 00502f74
    je.d32 L_00503046                            # 00502f77
    # block 0x00502f7d: entered by fall-through of je at 0x00502f77, 7 instruction(s), ends with jl to 0x00502f69 (backward)
    mov ecx, dword ptr [esi + field_8]           # 00502f7d
    inc eax                                      # 00502f80
    mov dword ptr [ecx + 4*edi], eax             # 00502f81
    mov eax, dword ptr [esi + field_4]           # 00502f84
    inc edi                                      # 00502f87
    {load} cmp edi, eax                          # 00502f88
    jl.d8 L_00502f69                             # 00502f8a
L_00502f8c:
    # block 0x00502f8c: entered by jle at 0x00502eb4; jmp at 0x00502ef4; jle at 0x00502f1e; jmp at 0x00502f5e; more, 7 instruction(s), calls FUN_0050be60, ends with je to 0x00503057 (forward)
    push 0x4                                     # 00502f8c
    push ebx                                     # 00502f8e
    call FUN_0050be60                            # 00502f8f
    add esp, 0x8                                 # 00502f94
    mov dword ptr [esi + field_c], eax           # 00502f97
    test eax, eax                                # 00502f9a
    je.d32 L_00503057                            # 00502f9c
    # block 0x00502fa2: entered by fall-through of je at 0x00502f9c, 1 instruction(s), ends with jle to 0x00503046 (forward)
    jle.d32 L_00503046                           # 00502fa2
    # block 0x00502fa8: entered by fall-through of jle at 0x00502fa2, 2 instruction(s), ends with jg to 0x00503046 (forward)
    cmp eax, 0x2                                 # 00502fa8
    jg.d32 L_00503046                            # 00502fab
    # block 0x00502fb1: entered by fall-through of jg at 0x00502fab, 22 instruction(s), calls FUN_0050be60, ends with je to 0x00502ff4 (forward)
    push 0x20                                    # 00502fb1
    push ebx                                     # 00502fb3
    call FUN_0050be60                            # 00502fb4
    push 0x20                                    # 00502fb9
    push ebx                                     # 00502fbb
    mov dword ptr [esi + field_10], eax          # 00502fbc
    call FUN_0050be60                            # 00502fbf
    push 0x4                                     # 00502fc4
    push ebx                                     # 00502fc6
    mov dword ptr [esi + field_14], eax          # 00502fc7
    call FUN_0050be60                            # 00502fca
    inc eax                                      # 00502fcf
    push 0x1                                     # 00502fd0
    push ebx                                     # 00502fd2
    mov dword ptr [esi + field_18], eax          # 00502fd3
    call FUN_0050be60                            # 00502fd6
    mov dword ptr [esi + field_1c], eax          # 00502fdb
    mov eax, dword ptr [esi + field_c]           # 00502fde
    add esp, 0x20                                # 00502fe1
    {load} xor edi, edi                          # 00502fe4
    dec eax                                      # 00502fe6
    je.d8 L_00502ff4                             # 00502fe7
    # block 0x00502fe9: entered by fall-through of je at 0x00502fe7, 2 instruction(s), ends with jne to 0x00502fff (forward)
    dec eax                                      # 00502fe9
    jne.d8 L_00502fff                            # 00502fea
    # block 0x00502fec: entered by fall-through of jne at 0x00502fea, 3 instruction(s), ends with forward jump to 0x00502fff
    mov edi, dword ptr [esi]                     # 00502fec
    imul edi, dword ptr [esi + field_4]          # 00502fee
    jmp.d8 L_00502fff                            # 00502ff2
L_00502ff4:
    # block 0x00502ff4: entered by je at 0x00502fe7, 4 instruction(s), calls FUN_005025c0, falls into the block at 0x00502fff
    push esi                                     # 00502ff4
    call FUN_005025c0                            # 00502ff5
    add esp, 0x4                                 # 00502ffa
    {load} mov edi, eax                          # 00502ffd
L_00502fff:
    # block 0x00502fff: entered by jne at 0x00502fea; jmp at 0x00502ff2, 9 instruction(s), calls FUN_0050ea90, ends with jle to 0x00503036 (forward)
    lea eax, [4*edi]                             # 00502fff
    push eax                                     # 00503006
    mov dword ptr [esp + stk_1c], eax            # 00503007
    call FUN_0050ea90                            # 0050300b
    add esp, 0x4                                 # 00503010
    {load} xor ebp, ebp                          # 00503013
    test edi, edi                                # 00503015
    mov dword ptr [esi + field_20], eax          # 00503017
    jle.d8 L_00503036                            # 0050301a
L_0050301c:
    # block 0x0050301c: entered by jl at 0x00503032; fall-through of jle at 0x0050301a, 10 instruction(s), calls FUN_0050be60, ends with jl to 0x0050301c (backward)
    mov edx, dword ptr [esi + field_18]          # 0050301c
    push edx                                     # 0050301f
    push ebx                                     # 00503020
    call FUN_0050be60                            # 00503021
    mov ecx, dword ptr [esi + field_20]          # 00503026
    add esp, 0x8                                 # 00503029
    mov dword ptr [ecx + 4*ebp], eax             # 0050302c
    inc ebp                                      # 0050302f
    {load} cmp ebp, edi                          # 00503030
    jl.d8 L_0050301c                             # 00503032
    # block 0x00503034: entered by fall-through of jl at 0x00503032, 1 instruction(s), falls into the block at 0x00503036
    test edi, edi                                # 00503034
L_00503036:
    # block 0x00503036: entered by jle at 0x0050301a, 1 instruction(s), ends with je to 0x00503057 (forward)
    je.d8 L_00503057                             # 00503036
    # block 0x00503038: entered by fall-through of je at 0x00503036, 4 instruction(s), ends with jne to 0x00503057 (forward)
    mov edx, dword ptr [esi + field_20]          # 00503038
    mov eax, dword ptr [esp + stk_18]            # 0050303b
    cmp dword ptr [eax + edx - field_minus_4], -0x1 # 0050303f
    jne.d8 L_00503057                            # 00503044
L_00503046:
    # block 0x00503046: entered by jne at 0x00502e4e; je at 0x00502e6f; je at 0x00502ecf; je at 0x00502f3d; more, 9 instruction(s), calls FUN_00502820, ends with ret
    push esi                                     # 00503046
    call FUN_00502820                            # 00503047
    add esp, 0x4                                 # 0050304c
    or eax, -0x1                                 # 0050304f
    pop edi                                      # 00503052
    pop esi                                      # 00503053
    pop ebp                                      # 00503054
    pop ebx                                      # 00503055
    ret                                          # 00503056
L_00503057:
    # block 0x00503057: entered by je at 0x00502f9c; je at 0x00503036; jne at 0x00503044, 6 instruction(s), ends with ret
    pop edi                                      # 00503057
    pop esi                                      # 00503058
    pop ebp                                      # 00503059
    {load} xor eax, eax                          # 0050305a
    pop ebx                                      # 0050305c
    ret                                          # 0050305d

# --- data items (not part of the function) -------------------------
.org 0x0050305e - 0x401000
PAD_0050305e:  # 2 byte(s) of nop padding
    .fill 2, 1, 0x90

