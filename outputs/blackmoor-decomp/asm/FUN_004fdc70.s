# FUN_004fdc70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fdc70
# extent:       0x004fdc70-0x004fdf36 (710 code bytes)
# span:         0x004fdc70-0x004fdf40 (code 710, tables 0, padding 10)
# sha256:       7c9948c9738a3be664f7ebcfa6b8520cd8a39e62d4e3fb9d4e66b6477af5b675
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fdc70
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_1c; [ebx + n] field_4; [esi + n] field_4, field_10, field_14, field_34, field_40, field_44, field_48, field_50, field_54, field_58, field_5c, field_60 and 1 more; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_28, stk_2c, stk_38, stk_3c, stk_48, stk_4c, stk_50 and 4 more
# callees:      calls FUN_004fdf40, FUN_004fd650, FUN_0050b2c0, FUN_0050ba70, FUN_004ffb90, FUN_004fd2b0, FUN_0050b260, FUN_0050b330, FUN_0050ba50, FUN_0050b6f0, FUN_0050b170, FUN_004fdc00
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 248 instruction(s), 30 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_10, 0x10  # offset +0x10
.equ stk_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ field_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ stk_48, 0x48  # offset +0x48
.equ field_48, 0x48  # offset +0x48
.equ stk_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ stk_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ stk_58, 0x58  # offset +0x58
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_74, 0x74  # offset +0x74
.equ stk_1b0, 0x1b0  # offset +0x1b0
.equ stk_1b8, 0x1b8  # offset +0x1b8
.equ stk_1bc, 0x1bc  # offset +0x1bc

# --- external targets -----------------------------------------------
.set FUN_004fd2b0, .text + (0x004fd2b0 - 0x401000)
.set FUN_004fd650, .text + (0x004fd650 - 0x401000)
.set FUN_004fdc00, .text + (0x004fdc00 - 0x401000)
.set FUN_004fdf40, .text + (0x004fdf40 - 0x401000)
.set FUN_004ffb90, .text + (0x004ffb90 - 0x401000)
.set FUN_0050b170, .text + (0x0050b170 - 0x401000)
.set FUN_0050b260, .text + (0x0050b260 - 0x401000)
.set FUN_0050b2c0, .text + (0x0050b2c0 - 0x401000)
.set FUN_0050b330, .text + (0x0050b330 - 0x401000)
.set FUN_0050b6f0, .text + (0x0050b6f0 - 0x401000)
.set FUN_0050ba50, .text + (0x0050ba50 - 0x401000)
.set FUN_0050ba70, .text + (0x0050ba70 - 0x401000)

.org 0x004fdc70 - 0x401000
.globl FUN_004fdc70
FUN_004fdc70:
    # block 0x004fdc70: entry, 8 instruction(s), ends with jl to 0x004fdf26 (forward)
    sub esp, 0x1a0                               # 004fdc70
    push ebx                                     # 004fdc76
    push ebp                                     # 004fdc77
    push esi                                     # 004fdc78
    mov esi, dword ptr [esp + stk_1b0]           # 004fdc79
    push edi                                     # 004fdc80
    cmp dword ptr [esi + field_58], 0x2          # 004fdc81
    jl.d32 L_004fdf26                            # 004fdc85
    # block 0x004fdc8b: entered by fall-through of jl at 0x004fdc85, 3 instruction(s), ends with jne to 0x004fdca2 (forward)
    mov eax, dword ptr [esi + field_4]           # 004fdc8b
    test eax, eax                                # 004fdc8e
    jne.d8 L_004fdca2                            # 004fdc90
    # block 0x004fdc92: entered by fall-through of jne at 0x004fdc90, 7 instruction(s), ends with ret
    pop edi                                      # 004fdc92
    pop esi                                      # 004fdc93
    pop ebp                                      # 004fdc94
    mov eax, 0xffffff76                          # 004fdc95
    pop ebx                                      # 004fdc9a
    add esp, 0x1a0                               # 004fdc9b
    ret                                          # 004fdca1
L_004fdca2:
    # block 0x004fdca2: entered by jne at 0x004fdc90, 4 instruction(s), ends with jl to 0x004fdf26 (forward)
    mov edi, dword ptr [esp + stk_1bc]           # 004fdca2
    mov ebx, dword ptr [esp + stk_1b8]           # 004fdca9
    test edi, edi                                # 004fdcb0
    jl.d32 L_004fdf26                            # 004fdcb2
    # block 0x004fdcb8: entered by fall-through of jl at 0x004fdcb2, 1 instruction(s), ends with jg to 0x004fdcc2 (forward)
    jg.d8 L_004fdcc2                             # 004fdcb8
    # block 0x004fdcba: entered by fall-through of jg at 0x004fdcb8, 2 instruction(s), ends with jb to 0x004fdf26 (forward)
    test ebx, ebx                                # 004fdcba
    jb.d32 L_004fdf26                            # 004fdcbc
L_004fdcc2:
    # block 0x004fdcc2: entered by jg at 0x004fdcb8; fall-through of jb at 0x004fdcbc, 2 instruction(s), ends with jg to 0x004fdf26 (forward)
    cmp edi, dword ptr [esi + field_14]          # 004fdcc2
    jg.d32 L_004fdf26                            # 004fdcc5
    # block 0x004fdccb: entered by fall-through of jg at 0x004fdcc5, 1 instruction(s), ends with jl to 0x004fdcd6 (forward)
    jl.d8 L_004fdcd6                             # 004fdccb
    # block 0x004fdccd: entered by fall-through of jl at 0x004fdccb, 2 instruction(s), ends with ja to 0x004fdf26 (forward)
    cmp ebx, dword ptr [esi + field_10]          # 004fdccd
    ja.d32 L_004fdf26                            # 004fdcd0
L_004fdcd6:
    # block 0x004fdcd6: entered by jl at 0x004fdccb; fall-through of ja at 0x004fdcd0, 17 instruction(s), calls FUN_004fdf40, FUN_004fd650, FUN_0050b2c0, falls into the block at 0x004fdd06
    or eax, -0x1                                 # 004fdcd6
    push esi                                     # 004fdcd9
    mov dword ptr [esi + field_50], eax          # 004fdcda
    mov dword ptr [esi + field_54], eax          # 004fdcdd
    call FUN_004fdf40                            # 004fdce0
    push edi                                     # 004fdce5
    push ebx                                     # 004fdce6
    push esi                                     # 004fdce7
    call FUN_004fd650                            # 004fdce8
    lea eax, [esp + stk_58]                      # 004fdced
    {load} xor ebp, ebp                          # 004fdcf1
    push -0x1                                    # 004fdcf3
    push eax                                     # 004fdcf5
    mov dword ptr [esp + stk_28], ebp            # 004fdcf6
    call FUN_0050b2c0                            # 004fdcfa
    mov ebx, dword ptr [esp + stk_2c]            # 004fdcff
    add esp, 0x18                                # 004fdd03
L_004fdd06:
    # block 0x004fdd06: entered by jmp at 0x004fdd94; jmp at 0x004fde78, 4 instruction(s), ends with jne to 0x004fdd99 (forward)
    mov eax, dword ptr [esi + field_58]          # 004fdd06
    mov edi, 0x3                                 # 004fdd09
    {load} cmp eax, edi                          # 004fdd0e
    jne.d32 L_004fdd99                           # 004fdd10
    # block 0x004fdd16: entered by fall-through of jne at 0x004fdd10, 8 instruction(s), calls FUN_0050ba70, ends with jle to 0x004fdd99 (forward)
    lea ecx, [esp + stk_28]                      # 004fdd16
    lea edx, [esp + stk_48]                      # 004fdd1a
    push ecx                                     # 004fdd1e
    push edx                                     # 004fdd1f
    call FUN_0050ba70                            # 004fdd20
    add esp, 0x8                                 # 004fdd25
    test eax, eax                                # 004fdd28
    jle.d8 L_004fdd99                            # 004fdd2a
    # block 0x004fdd2c: entered by fall-through of jle at 0x004fdd2a, 7 instruction(s), ends with je to 0x004fdd50 (forward)
    mov eax, dword ptr [esi + field_60]          # 004fdd2c
    mov ecx, dword ptr [esi + field_48]          # 004fdd2f
    shl eax, 0x5                                 # 004fdd32
    {load} add eax, ecx                          # 004fdd35
    mov ecx, dword ptr [eax + field_1c]          # 004fdd37
    test ecx, ecx                                # 004fdd3a
    je.d8 L_004fdd50                             # 004fdd3c
    # block 0x004fdd3e: entered by fall-through of je at 0x004fdd3c, 6 instruction(s), calls FUN_004ffb90, falls into the block at 0x004fdd50
    lea edx, [esp + stk_28]                      # 004fdd3e
    push edx                                     # 004fdd42
    push eax                                     # 004fdd43
    call FUN_004ffb90                            # 004fdd44
    add esp, 0x8                                 # 004fdd49
    mov dword ptr [esp + stk_14], eax            # 004fdd4c
L_004fdd50:
    # block 0x004fdd50: entered by je at 0x004fdd3c, 2 instruction(s), ends with je to 0x004fdd64 (forward)
    test ebx, ebx                                # 004fdd50
    je.d8 L_004fdd64                             # 004fdd52
    # block 0x004fdd54: entered by fall-through of je at 0x004fdd52, 6 instruction(s), calls FUN_0050ba70, ends with forward jump to 0x004fdd7b
    lea eax, [esi + field_74]                    # 004fdd54
    push 0x0                                     # 004fdd57
    push eax                                     # 004fdd59
    call FUN_0050ba70                            # 004fdd5a
    add esp, 0x8                                 # 004fdd5f
    jmp.d8 L_004fdd7b                            # 004fdd62
L_004fdd64:
    # block 0x004fdd64: entered by je at 0x004fdd52, 2 instruction(s), ends with je to 0x004fdd7b (forward)
    test ebp, ebp                                # 004fdd64
    je.d8 L_004fdd7b                             # 004fdd66
    # block 0x004fdd68: entered by fall-through of je at 0x004fdd66, 6 instruction(s), falls into the block at 0x004fdd7b
    mov ecx, dword ptr [esp + stk_14]            # 004fdd68
    mov eax, dword ptr [esp + stk_10]            # 004fdd6c
    {load} add ecx, ebp                          # 004fdd70
    sar ecx, 0x2                                 # 004fdd72
    {load} add eax, ecx                          # 004fdd75
    mov dword ptr [esp + stk_10], eax            # 004fdd77
L_004fdd7b:
    # block 0x004fdd7b: entered by jmp at 0x004fdd62; je at 0x004fdd66, 6 instruction(s), ends with jne to 0x004fde7d (forward)
    mov edi, dword ptr [esp + stk_38]            # 004fdd7b
    mov ecx, dword ptr [esp + stk_3c]            # 004fdd7f
    {load} mov edx, edi                          # 004fdd83
    {load} and edx, ecx                          # 004fdd85
    cmp edx, -0x1                                # 004fdd87
    jne.d32 L_004fde7d                           # 004fdd8a
    # block 0x004fdd90: entered by fall-through of jne at 0x004fdd8a, 2 instruction(s), ends with backward jump to 0x004fdd06
    mov ebp, dword ptr [esp + stk_14]            # 004fdd90
    jmp.d32 L_004fdd06                           # 004fdd94
L_004fdd99:
    # block 0x004fdd99: entered by jne at 0x004fdd10; jle at 0x004fdd2a, 2 instruction(s), ends with jne to 0x004fdf03 (forward)
    test ebp, ebp                                # 004fdd99
    jne.d32 L_004fdf03                           # 004fdd9b
    # block 0x004fdda1: entered by fall-through of jne at 0x004fdd9b, 9 instruction(s), calls FUN_004fd2b0, ends with jl to 0x004fdec4 (forward)
    push -0x1                                    # 004fdda1
    lea eax, [esp + stk_1c]                      # 004fdda3
    push -0x1                                    # 004fdda7
    push eax                                     # 004fdda9
    push esi                                     # 004fddaa
    call FUN_004fd2b0                            # 004fddab
    add esp, 0x10                                # 004fddb0
    test edx, edx                                # 004fddb3
    jl.d32 L_004fdec4                            # 004fddb5
    # block 0x004fddbb: entered by fall-through of jl at 0x004fddb5, 1 instruction(s), ends with jg to 0x004fddc5 (forward)
    jg.d8 L_004fddc5                             # 004fddbb
    # block 0x004fddbd: entered by fall-through of jg at 0x004fddbb, 2 instruction(s), ends with jb to 0x004fdec4 (forward)
    test eax, eax                                # 004fddbd
    jb.d32 L_004fdec4                            # 004fddbf
L_004fddc5:
    # block 0x004fddc5: entered by jg at 0x004fddbb; fall-through of jb at 0x004fddbf, 2 instruction(s), ends with jne to 0x004fddf4 (forward)
    cmp dword ptr [esi + field_58], edi          # 004fddc5
    jne.d8 L_004fddf4                            # 004fddc8
    # block 0x004fddca: entered by fall-through of jne at 0x004fddc8, 7 instruction(s), calls FUN_0050b260, ends with je to 0x004fddf1 (forward)
    lea ecx, [esp + stk_18]                      # 004fddca
    push ecx                                     # 004fddce
    call FUN_0050b260                            # 004fddcf
    mov ecx, dword ptr [esi + field_5c]          # 004fddd4
    add esp, 0x4                                 # 004fddd7
    {load} cmp ecx, eax                          # 004fddda
    je.d8 L_004fddf1                             # 004fdddc
    # block 0x004fddde: entered by fall-through of je at 0x004fdddc, 6 instruction(s), calls FUN_004fdf40, FUN_0050b330, falls into the block at 0x004fddf1
    push esi                                     # 004fddde
    call FUN_004fdf40                            # 004fdddf
    lea edx, [esp + stk_4c]                      # 004fdde4
    push edx                                     # 004fdde8
    call FUN_0050b330                            # 004fdde9
    add esp, 0x8                                 # 004fddee
L_004fddf1:
    # block 0x004fddf1: entered by je at 0x004fdddc, 1 instruction(s), falls into the block at 0x004fddf4
    cmp dword ptr [esi + field_58], edi          # 004fddf1
L_004fddf4:
    # block 0x004fddf4: entered by jne at 0x004fddc8, 1 instruction(s), ends with jge to 0x004fde4c (forward)
    jge.d8 L_004fde4c                            # 004fddf4
    # block 0x004fddf6: entered by fall-through of jge at 0x004fddf4, 9 instruction(s), calls FUN_0050b260, ends with jle to 0x004fde23 (forward)
    lea eax, [esp + stk_18]                      # 004fddf6
    push eax                                     # 004fddfa
    call FUN_0050b260                            # 004fddfb
    mov edx, dword ptr [esi + field_34]          # 004fde00
    add esp, 0x4                                 # 004fde03
    {load} xor ecx, ecx                          # 004fde06
    mov dword ptr [esi + field_5c], eax          # 004fde08
    test edx, edx                                # 004fde0b
    jle.d8 L_004fde23                            # 004fde0d
    # block 0x004fde0f: entered by fall-through of jle at 0x004fde0d, 1 instruction(s), falls into the block at 0x004fde12
    mov edi, dword ptr [esi + field_40]          # 004fde0f
L_004fde12:
    # block 0x004fde12: entered by jl at 0x004fde1c, 2 instruction(s), ends with je to 0x004fde1e (forward)
    cmp dword ptr [edi], eax                     # 004fde12
    je.d8 L_004fde1e                             # 004fde14
    # block 0x004fde16: entered by fall-through of je at 0x004fde14, 4 instruction(s), ends with jl to 0x004fde12 (backward)
    inc ecx                                      # 004fde16
    add edi, 0x4                                 # 004fde17
    {load} cmp ecx, edx                          # 004fde1a
    jl.d8 L_004fde12                             # 004fde1c
L_004fde1e:
    # block 0x004fde1e: entered by je at 0x004fde14; fall-through of jl at 0x004fde1c, 1 instruction(s), falls into the block at 0x004fde23
    mov edi, 0x3                                 # 004fde1e
L_004fde23:
    # block 0x004fde23: entered by jle at 0x004fde0d, 2 instruction(s), ends with je to 0x004fded7 (forward)
    {load} cmp ecx, edx                          # 004fde23
    je.d32 L_004fded7                            # 004fde25
    # block 0x004fde2b: entered by fall-through of je at 0x004fde25, 12 instruction(s), calls FUN_0050ba50, falls into the block at 0x004fde4c
    mov dword ptr [esi + field_60], ecx          # 004fde2b
    lea ecx, [esi + field_74]                    # 004fde2e
    push eax                                     # 004fde31
    push ecx                                     # 004fde32
    call FUN_0050ba50                            # 004fde33
    mov edx, dword ptr [esi + field_5c]          # 004fde38
    lea eax, [esp + stk_50]                      # 004fde3b
    push edx                                     # 004fde3f
    push eax                                     # 004fde40
    call FUN_0050ba50                            # 004fde41
    add esp, 0x10                                # 004fde46
    mov dword ptr [esi + field_58], edi          # 004fde49
L_004fde4c:
    # block 0x004fde4c: entered by jge at 0x004fddf4, 16 instruction(s), calls FUN_0050b6f0, FUN_0050b170, ends with backward jump to 0x004fdd06
    lea ecx, [esp + stk_18]                      # 004fde4c
    lea edx, [esi + field_74]                    # 004fde50
    push ecx                                     # 004fde53
    push edx                                     # 004fde54
    call FUN_0050b6f0                            # 004fde55
    lea eax, [esp + stk_20]                      # 004fde5a
    lea ecx, [esp + stk_50]                      # 004fde5e
    push eax                                     # 004fde62
    push ecx                                     # 004fde63
    call FUN_0050b6f0                            # 004fde64
    lea edx, [esp + stk_28]                      # 004fde69
    push edx                                     # 004fde6d
    call FUN_0050b170                            # 004fde6e
    add esp, 0x14                                # 004fde73
    {load} mov ebx, eax                          # 004fde76
    jmp.d32 L_004fdd06                           # 004fde78
L_004fde7d:
    # block 0x004fde7d: entered by jne at 0x004fdd8a, 8 instruction(s), ends with jg to 0x004fde9d (forward)
    mov edx, dword ptr [esi + field_60]          # 004fde7d
    mov eax, dword ptr [esi + field_44]          # 004fde80
    {load} mov ebx, edx                          # 004fde83
    shl ebx, 0x4                                 # 004fde85
    sub edi, dword ptr [ebx + eax]               # 004fde88
    sbb ecx, dword ptr [ebx + eax + field_4]     # 004fde8b
    test ecx, ecx                                # 004fde8f
    jg.d8 L_004fde9d                             # 004fde91
    # block 0x004fde93: entered by fall-through of jg at 0x004fde91, 1 instruction(s), ends with jl to 0x004fde99 (forward)
    jl.d8 L_004fde99                             # 004fde93
    # block 0x004fde95: entered by fall-through of jl at 0x004fde93, 2 instruction(s), ends with jae to 0x004fde9d (forward)
    test edi, edi                                # 004fde95
    jae.d8 L_004fde9d                            # 004fde97
L_004fde99:
    # block 0x004fde99: entered by jl at 0x004fde93; fall-through of jae at 0x004fde97, 2 instruction(s), falls into the block at 0x004fde9d
    {load} xor edi, edi                          # 004fde99
    {load} xor ecx, ecx                          # 004fde9b
L_004fde9d:
    # block 0x004fde9d: entered by jg at 0x004fde91; jae at 0x004fde97, 2 instruction(s), ends with jle to 0x004fdeb3 (forward)
    test edx, edx                                # 004fde9d
    jle.d8 L_004fdeb3                            # 004fde9f
    # block 0x004fdea1: entered by fall-through of jle at 0x004fde9f, 1 instruction(s), falls into the block at 0x004fdea4
    add eax, 0x8                                 # 004fdea1
L_004fdea4:
    # block 0x004fdea4: entered by jne at 0x004fdeb1, 7 instruction(s), ends with jne to 0x004fdea4 (backward)
    mov ebx, dword ptr [eax]                     # 004fdea4
    mov ebp, dword ptr [eax + field_4]           # 004fdea6
    {load} add edi, ebx                          # 004fdea9
    {load} adc ecx, ebp                          # 004fdeab
    add eax, 0x10                                # 004fdead
    dec edx                                      # 004fdeb0
    jne.d8 L_004fdea4                            # 004fdeb1
L_004fdeb3:
    # block 0x004fdeb3: entered by jle at 0x004fde9f; fall-through of jne at 0x004fdeb1, 7 instruction(s), ends with forward jump to 0x004fdf0c
    mov eax, dword ptr [esp + stk_10]            # 004fdeb3
    cdq                                          # 004fdeb7
    {load} sub edi, eax                          # 004fdeb8
    {load} sbb ecx, edx                          # 004fdeba
    mov dword ptr [esi + field_50], edi          # 004fdebc
    mov dword ptr [esi + field_54], ecx          # 004fdebf
    jmp.d8 L_004fdf0c                            # 004fdec2
L_004fdec4:
    # block 0x004fdec4: entered by jl at 0x004fddb5; jb at 0x004fddbf, 7 instruction(s), calls FUN_004fdc00, ends with forward jump to 0x004fdf0c
    push -0x1                                    # 004fdec4
    push esi                                     # 004fdec6
    call FUN_004fdc00                            # 004fdec7
    mov dword ptr [esi + field_50], eax          # 004fdecc
    add esp, 0x8                                 # 004fdecf
    mov dword ptr [esi + field_54], edx          # 004fded2
    jmp.d8 L_004fdf0c                            # 004fded5
L_004fded7:
    # block 0x004fded7: entered by je at 0x004fde25, 16 instruction(s), calls FUN_0050b330, FUN_004fdf40, ends with ret
    or eax, -0x1                                 # 004fded7
    mov dword ptr [esi + field_50], eax          # 004fdeda
    mov dword ptr [esi + field_54], eax          # 004fdedd
    lea eax, [esp + stk_48]                      # 004fdee0
    push eax                                     # 004fdee4
    call FUN_0050b330                            # 004fdee5
    push esi                                     # 004fdeea
    call FUN_004fdf40                            # 004fdeeb
    add esp, 0x8                                 # 004fdef0
    mov eax, 0xffffff77                          # 004fdef3
    pop edi                                      # 004fdef8
    pop esi                                      # 004fdef9
    pop ebp                                      # 004fdefa
    pop ebx                                      # 004fdefb
    add esp, 0x1a0                               # 004fdefc
    ret                                          # 004fdf02
L_004fdf03:
    # block 0x004fdf03: entered by jne at 0x004fdd9b, 3 instruction(s), falls into the block at 0x004fdf0c
    or eax, -0x1                                 # 004fdf03
    mov dword ptr [esi + field_50], eax          # 004fdf06
    mov dword ptr [esi + field_54], eax          # 004fdf09
L_004fdf0c:
    # block 0x004fdf0c: entered by jmp at 0x004fdec2; jmp at 0x004fded5, 11 instruction(s), calls FUN_0050b330, ends with ret
    lea ecx, [esp + stk_48]                      # 004fdf0c
    push ecx                                     # 004fdf10
    call FUN_0050b330                            # 004fdf11
    add esp, 0x4                                 # 004fdf16
    {load} xor eax, eax                          # 004fdf19
    pop edi                                      # 004fdf1b
    pop esi                                      # 004fdf1c
    pop ebp                                      # 004fdf1d
    pop ebx                                      # 004fdf1e
    add esp, 0x1a0                               # 004fdf1f
    ret                                          # 004fdf25
L_004fdf26:
    # block 0x004fdf26: entered by jl at 0x004fdc85; jl at 0x004fdcb2; jb at 0x004fdcbc; jg at 0x004fdcc5; ja at 0x004fdcd0, 7 instruction(s), ends with ret
    pop edi                                      # 004fdf26
    pop esi                                      # 004fdf27
    pop ebp                                      # 004fdf28
    mov eax, 0xffffff7d                          # 004fdf29
    pop ebx                                      # 004fdf2e
    add esp, 0x1a0                               # 004fdf2f
    ret                                          # 004fdf35

# --- data items (not part of the function) -------------------------
.org 0x004fdf36 - 0x401000
PAD_004fdf36:  # 10 byte(s) of nop padding
    .fill 10, 1, 0x90

