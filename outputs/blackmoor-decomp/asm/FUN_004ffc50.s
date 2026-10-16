# FUN_004ffc50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ffc50
# extent:       0x004ffc50-0x00500194 (1348 code bytes)
# span:         0x004ffc50-0x005001a0 (code 1348, tables 0, padding 12)
# sha256:       4a5489fa3e192d8f7c3aa90440eacade349769f9022eea1f9985cbc1724b8643
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ffc50
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1, field_18, field_1c, field_74, field_78, field_7c; [ecx + n] field_minus_4; [edi + n] field_70; [edx + n] field_minus_4; [esi + n] field_4, field_8, field_c, field_10, field_14, field_18, field_1c, field_20, field_24, field_28, field_2c; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_2c, stk_34, stk_38, stk_3c, stk_40, stk_44 and 4 more; [scaled index + n] field_88
# callees:      calls FUN_0050e19e, FUN_0050ce04, FUN_0050ea90, FUN_005001a0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 414 instruction(s), 21 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ stk_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ stk_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ field_2c, 0x2c  # offset +0x2c
.equ stk_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c
.equ stk_40, 0x40  # offset +0x40
.equ stk_44, 0x44  # offset +0x44
.equ stk_48, 0x48  # offset +0x48
.equ stk_4c, 0x4c  # offset +0x4c
.equ stk_50, 0x50  # offset +0x50
.equ stk_5c, 0x5c  # offset +0x5c
.equ field_70, 0x70  # offset +0x70
.equ field_74, 0x74  # offset +0x74
.equ field_78, 0x78  # offset +0x78
.equ field_7c, 0x7c  # offset +0x7c
.equ field_88, 0x88  # offset +0x88

# --- external targets -----------------------------------------------
.set FUN_005001a0, .text + (0x005001a0 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0050e19e, .text + (0x0050e19e - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)

.org 0x004ffc50 - 0x401000
.globl FUN_004ffc50
FUN_004ffc50:
    # block 0x004ffc50: entry, 94 instruction(s), calls FUN_0050e19e, FUN_0050ce04, FUN_0050ea90, falls into the block at 0x004ffd8c
    sub esp, 0x24                                # 004ffc50
    push ebx                                     # 004ffc53
    push ebp                                     # 004ffc54
    push esi                                     # 004ffc55
    mov esi, dword ptr [esp + stk_34]            # 004ffc56
    push edi                                     # 004ffc5a
    mov ecx, 0xc                                 # 004ffc5b
    {load} xor eax, eax                          # 004ffc60
    {load} mov edi, esi                          # 004ffc62
    rep stosd dword ptr es:[edi], eax            # 004ffc64
    mov edi, dword ptr [esp + stk_40]            # 004ffc66
    sub esp, 0x8                                 # 004ffc6a
    mov dword ptr [esp + stk_18], 0xffffff9d     # 004ffc6d
    {load} xor ebp, ebp                          # 004ffc75
    mov eax, dword ptr [edi]                     # 004ffc77
    mov dword ptr [esi + field_24], eax          # 004ffc79
    fild dword ptr [edi]                         # 004ffc7c
    fmul dword ptr [0x52db58]                    # 004ffc7e
    fldln2                                       # 004ffc84
    fxch st(1)                                   # 004ffc86
    fyl2x                                        # 004ffc88
    fldln2                                       # 004ffc8a
    fld qword ptr [0x52c678]                     # 004ffc8c
    fyl2x                                        # 004ffc92
    fdivp st(1), st                              # 004ffc94
    fadd qword ptr [0x52cac0]                    # 004ffc96
    fstp qword ptr [esp]                         # 004ffc9c
    call FUN_0050e19e                            # 004ffc9f
    fsub qword ptr [0x52c598]                    # 004ffca4
    call FUN_0050ce04                            # 004ffcaa
    fild dword ptr [esp + stk_50]                # 004ffcaf
    fild dword ptr [esp + stk_4c]                # 004ffcb3
    lea ecx, [eax + field_1]                     # 004ffcb7
    mov edx, 0x1                                 # 004ffcba
    shl edx, cl                                  # 004ffcbf
    fst qword ptr [esp + stk_2c]                 # 004ffcc1
    mov dword ptr [esi + field_20], eax          # 004ffcc5
    mov dword ptr [esp + stk_40], edx            # 004ffcc8
    fild dword ptr [esp + stk_40]                # 004ffccc
    fld st(2)                                    # 004ffcd0
    fmul dword ptr [0x52e5d0]                    # 004ffcd2
    fmul qword ptr [0x52cac0]                    # 004ffcd8
    fdiv st, st(2)                               # 004ffcde
    fldln2                                       # 004ffce0
    fxch st(1)                                   # 004ffce2
    fyl2x                                        # 004ffce4
    fmul qword ptr [0x52e5c8]                    # 004ffce6
    fsub qword ptr [0x52e5c0]                    # 004ffcec
    fmul st, st(1)                               # 004ffcf2
    fisub dword ptr [edi]                        # 004ffcf4
    call FUN_0050ce04                            # 004ffcf6
    fild dword ptr [esp + stk_4c]                # 004ffcfb
    {load} mov edi, eax                          # 004ffcff
    mov dword ptr [esi + field_1c], edi          # 004ffd01
    fadd dword ptr [0x52e5d0]                    # 004ffd04
    fmul st, st(3)                               # 004ffd0a
    fmul qword ptr [0x52cac0]                    # 004ffd0c
    fdiv st, st(2)                               # 004ffd12
    fldln2                                       # 004ffd14
    fxch st(1)                                   # 004ffd16
    fyl2x                                        # 004ffd18
    fmul qword ptr [0x52e5c8]                    # 004ffd1a
    fsub qword ptr [0x52e5c0]                    # 004ffd20
    fmul st, st(1)                               # 004ffd26
    fadd qword ptr [0x52cac0]                    # 004ffd28
    call FUN_0050ce04                            # 004ffd2e
    {load} sub eax, edi                          # 004ffd33
    mov edi, dword ptr [esp + stk_4c]            # 004ffd35
    fstp st(0)                                   # 004ffd39
    lea ebx, [4*edi]                             # 004ffd3b
    inc eax                                      # 004ffd42
    fstp st(0)                                   # 004ffd43
    push ebx                                     # 004ffd45
    mov dword ptr [esi + field_28], eax          # 004ffd46
    fstp st(0)                                   # 004ffd49
    call FUN_0050ea90                            # 004ffd4b
    mov dword ptr [esi + field_10], eax          # 004ffd50
    push ebx                                     # 004ffd53
    call FUN_0050ea90                            # 004ffd54
    push ebx                                     # 004ffd59
    mov dword ptr [esi + field_14], eax          # 004ffd5a
    call FUN_0050ea90                            # 004ffd5d
    fild dword ptr [esp + stk_5c]                # 004ffd62
    mov ecx, dword ptr [esp + stk_5c]            # 004ffd66
    mov dword ptr [esi + field_18], eax          # 004ffd6a
    mov eax, dword ptr [esp + stk_50]            # 004ffd6d
    add esp, 0x14                                # 004ffd71
    fstp qword ptr [esp + stk_2c]                # 004ffd74
    mov dword ptr [esi + field_4], eax           # 004ffd78
    {load} xor eax, eax                          # 004ffd7b
    mov dword ptr [esi], edi                     # 004ffd7d
    mov dword ptr [esi + field_2c], ecx          # 004ffd7f
    {load} xor ebx, ebx                          # 004ffd82
    mov dword ptr [esp + stk_40], 0x560a7c       # 004ffd84
L_004ffd8c:
    # block 0x004ffd8c: entered by jl at 0x004ffe34, 31 instruction(s), calls FUN_0050e19e, FUN_0050ce04, ends with jge to 0x004ffe21 (forward)
    inc eax                                      # 004ffd8c
    sub esp, 0x8                                 # 004ffd8d
    mov dword ptr [esp + stk_40], eax            # 004ffd90
    fild dword ptr [esp + stk_40]                # 004ffd94
    fmul qword ptr [0x52e5b8]                    # 004ffd98
    fsub qword ptr [0x52c678]                    # 004ffd9e
    fadd qword ptr [0x52e5c0]                    # 004ffda4
    fmul qword ptr [0x52e5b0]                    # 004ffdaa
    fldl2e                                       # 004ffdb0
    fmulp st(1), st                              # 004ffdb2
    fld st(0)                                    # 004ffdb4
    frndint                                      # 004ffdb6
    fxch st(1)                                   # 004ffdb8
    fsub st, st(1)                               # 004ffdba
    f2xm1                                        # 004ffdbc
    fld1                                         # 004ffdbe
    faddp st(1), st                              # 004ffdc0
    fscale                                       # 004ffdc2
    fstp st(1)                                   # 004ffdc4
    fmul qword ptr [esp + stk_2c]                # 004ffdc6
    .insn 0xdc, 0xc0                             # 004ffdca
    fdiv qword ptr [esp + stk_34]                # 004ffdcc
    fadd qword ptr [0x52cac0]                    # 004ffdd0
    fstp qword ptr [esp]                         # 004ffdd6
    call FUN_0050e19e                            # 004ffdd9
    add esp, 0x8                                 # 004ffdde
    call FUN_0050ce04                            # 004ffde1
    mov ecx, dword ptr [esp + stk_40]            # 004ffde6
    {load} cmp ebx, eax                          # 004ffdea
    fld dword ptr [ecx - field_minus_4]          # 004ffdec
    jge.d8 L_004ffe21                            # 004ffdef
    # block 0x004ffdf1: entered by fall-through of jge at 0x004ffdef, 7 instruction(s), falls into the block at 0x004ffe05
    fld dword ptr [ecx]                          # 004ffdf1
    {load} mov edx, eax                          # 004ffdf3
    {load} sub edx, ebx                          # 004ffdf5
    mov dword ptr [esp + stk_40], edx            # 004ffdf7
    fsub st, st(1)                               # 004ffdfb
    fidiv dword ptr [esp + stk_40]               # 004ffdfd
    fstp dword ptr [esp + stk_40]                # 004ffe01
L_004ffe05:
    # block 0x004ffe05: entered by jl at 0x004ffe1f, 2 instruction(s), ends with jge to 0x004ffe21 (forward)
    {load} cmp ebx, edi                          # 004ffe05
    jge.d8 L_004ffe21                            # 004ffe07
    # block 0x004ffe09: entered by fall-through of jge at 0x004ffe07, 8 instruction(s), ends with jl to 0x004ffe05 (backward)
    mov edx, dword ptr [esi + field_10]          # 004ffe09
    inc ebx                                      # 004ffe0c
    fld st(0)                                    # 004ffe0d
    fadd qword ptr [0x52c680]                    # 004ffe0f
    {load} cmp ebx, eax                          # 004ffe15
    fstp dword ptr [edx + 4*ebx - field_minus_4] # 004ffe17
    fadd dword ptr [esp + stk_40]                # 004ffe1b
    jl.d8 L_004ffe05                             # 004ffe1f
L_004ffe21:
    # block 0x004ffe21: entered by jge at 0x004ffdef; jge at 0x004ffe07; fall-through of jl at 0x004ffe1f, 6 instruction(s), ends with jl to 0x004ffd8c (backward)
    mov eax, dword ptr [esp + stk_38]            # 004ffe21
    add ecx, 0x4                                 # 004ffe25
    cmp ecx, 0x560bd8                            # 004ffe28
    mov dword ptr [esp + stk_40], ecx            # 004ffe2e
    fstp st(0)                                   # 004ffe32
    jl.d32 L_004ffd8c                            # 004ffe34
    # block 0x004ffe3a: entered by fall-through of jl at 0x004ffe34, 4 instruction(s), ends with jle to 0x00500013 (forward)
    {load} xor eax, eax                          # 004ffe3a
    {load} xor ebx, ebx                          # 004ffe3c
    {load} cmp edi, eax                          # 004ffe3e
    jle.d32 L_00500013                           # 004ffe40
    # block 0x004ffe46: entered by fall-through of jle at 0x004ffe40, 9 instruction(s), falls into the block at 0x004ffe5f
    mov dword ptr [esp + stk_40], eax            # 004ffe46
    mov dword ptr [esp + stk_38], eax            # 004ffe4a
    mov eax, dword ptr [esp + stk_48]            # 004ffe4e
    lea ecx, [edi + edi]                         # 004ffe52
    cdq                                          # 004ffe55
    idiv ecx                                     # 004ffe56
    {load} mov ecx, eax                          # 004ffe58
    {load} mov edx, ecx                          # 004ffe5a
    imul edx, ecx                                # 004ffe5c
L_004ffe5f:
    # block 0x004ffe5f: entered by jl at 0x0050000b, 25 instruction(s), ends with jge to 0x004fff4e (forward)
    mov eax, dword ptr [esp + stk_38]            # 004ffe5f
    mov edi, dword ptr [esp + stk_10]            # 004ffe63
    imul eax, ebx                                # 004ffe67
    fild dword ptr [esp + stk_40]                # 004ffe6a
    mov dword ptr [esp + stk_48], eax            # 004ffe6e
    mov eax, dword ptr [esp + stk_3c]            # 004ffe72
    fild dword ptr [esp + stk_48]                # 004ffe76
    mov eax, dword ptr [eax + field_78]          # 004ffe7a
    {load} add eax, edi                          # 004ffe7d
    fmul dword ptr [0x52e5a8]                    # 004ffe7f
    fld1                                         # 004ffe85
    {load} cmp eax, ebx                          # 004ffe87
    fpatan                                       # 004ffe89
    fmul qword ptr [0x52e5a0]                    # 004ffe8b
    fld st(1)                                    # 004ffe91
    fmul dword ptr [0x52e598]                    # 004ffe93
    fld1                                         # 004ffe99
    fpatan                                       # 004ffe9b
    fmul qword ptr [0x52e590]                    # 004ffe9d
    faddp st(1), st                              # 004ffea3
    fxch st(1)                                   # 004ffea5
    fmul dword ptr [0x52e588]                    # 004ffea7
    faddp st(1), st                              # 004ffead
    fstp dword ptr [esp + stk_18]                # 004ffeaf
    jge.d32 L_004fff4e                           # 004ffeb3
    # block 0x004ffeb9: entered by fall-through of jge at 0x004ffeb3, 10 instruction(s), falls into the block at 0x004ffede
    mov edi, dword ptr [esp + stk_3c]            # 004ffeb9
    mov dword ptr [esp + stk_14], eax            # 004ffebd
    fld dword ptr [esp + stk_18]                 # 004ffec1
    fsub dword ptr [edi + field_70]              # 004ffec5
    {load} mov eax, ecx                          # 004ffec8
    {load} mov edi, edx                          # 004ffeca
    imul eax, dword ptr [esp + stk_10]           # 004ffecc
    imul edi, dword ptr [esp + stk_10]           # 004ffed1
    fstp dword ptr [esp + stk_20]                # 004ffed6
    mov dword ptr [esp + stk_48], eax            # 004ffeda
L_004ffede:
    # block 0x004ffede: entered by jl at 0x004fff4c, 23 instruction(s), ends with jne to 0x004fff4e (forward)
    {load} mov eax, edi                          # 004ffede
    imul eax, dword ptr [esp + stk_10]           # 004ffee0
    fild dword ptr [esp + stk_48]                # 004ffee5
    mov dword ptr [esp + stk_1c], eax            # 004ffee9
    fild dword ptr [esp + stk_1c]                # 004ffeed
    fmul dword ptr [0x52e5a8]                    # 004ffef1
    fld1                                         # 004ffef7
    fpatan                                       # 004ffef9
    fmul qword ptr [0x52e5a0]                    # 004ffefb
    fld st(1)                                    # 004fff01
    fmul dword ptr [0x52e598]                    # 004fff03
    fld1                                         # 004fff09
    fpatan                                       # 004fff0b
    fmul qword ptr [0x52e590]                    # 004fff0d
    faddp st(1), st                              # 004fff13
    fxch st(1)                                   # 004fff15
    fmul dword ptr [0x52e588]                    # 004fff17
    faddp st(1), st                              # 004fff1d
    fld dword ptr [esp + stk_20]                 # 004fff1f
    fcompp                                       # 004fff23
    fnstsw ax                                    # 004fff25
    test ah, 0x41                                # 004fff27
    jne.d8 L_004fff4e                            # 004fff2a
    # block 0x004fff2c: entered by fall-through of jne at 0x004fff2a, 12 instruction(s), ends with jl to 0x004ffede (backward)
    mov eax, dword ptr [esp + stk_10]            # 004fff2c
    {load} add edi, edx                          # 004fff30
    inc eax                                      # 004fff32
    mov dword ptr [esp + stk_10], eax            # 004fff33
    mov eax, dword ptr [esp + stk_48]            # 004fff37
    {load} add eax, ecx                          # 004fff3b
    mov dword ptr [esp + stk_48], eax            # 004fff3d
    mov eax, dword ptr [esp + stk_14]            # 004fff41
    inc eax                                      # 004fff45
    {load} cmp eax, ebx                          # 004fff46
    mov dword ptr [esp + stk_14], eax            # 004fff48
    jl.d8 L_004ffede                             # 004fff4c
L_004fff4e:
    # block 0x004fff4e: entered by jge at 0x004ffeb3; jne at 0x004fff2a; fall-through of jl at 0x004fff4c, 2 instruction(s), ends with jge to 0x004fffe1 (forward)
    cmp ebp, dword ptr [esp + stk_44]            # 004fff4e
    jge.d32 L_004fffe1                           # 004fff52
    # block 0x004fff58: entered by fall-through of jge at 0x004fff52, 9 instruction(s), falls into the block at 0x004fff73
    mov eax, dword ptr [esp + stk_3c]            # 004fff58
    {load} mov edi, edx                          # 004fff5c
    mov eax, dword ptr [eax + field_7c]          # 004fff5e
    {load} add eax, ebx                          # 004fff61
    mov dword ptr [esp + stk_20], eax            # 004fff63
    {load} mov eax, ecx                          # 004fff67
    imul eax, ebp                                # 004fff69
    imul edi, ebp                                # 004fff6c
    mov dword ptr [esp + stk_48], eax            # 004fff6f
L_004fff73:
    # block 0x004fff73: entered by jl at 0x004fffdf, 2 instruction(s), ends with jl to 0x004fffcc (forward)
    cmp ebp, dword ptr [esp + stk_20]            # 004fff73
    jl.d8 L_004fffcc                             # 004fff77
    # block 0x004fff79: entered by fall-through of jl at 0x004fff77, 25 instruction(s), ends with jne to 0x004fffe1 (forward)
    {load} mov eax, edi                          # 004fff79
    imul eax, ebp                                # 004fff7b
    fild dword ptr [esp + stk_48]                # 004fff7e
    mov dword ptr [esp + stk_1c], eax            # 004fff82
    mov eax, dword ptr [esp + stk_3c]            # 004fff86
    fild dword ptr [esp + stk_1c]                # 004fff8a
    fmul dword ptr [0x52e5a8]                    # 004fff8e
    fld1                                         # 004fff94
    fpatan                                       # 004fff96
    fmul qword ptr [0x52e5a0]                    # 004fff98
    fld st(1)                                    # 004fff9e
    fmul dword ptr [0x52e598]                    # 004fffa0
    fld1                                         # 004fffa6
    fpatan                                       # 004fffa8
    fmul qword ptr [0x52e590]                    # 004fffaa
    faddp st(1), st                              # 004fffb0
    fxch st(1)                                   # 004fffb2
    fmul dword ptr [0x52e588]                    # 004fffb4
    faddp st(1), st                              # 004fffba
    fld dword ptr [esp + stk_18]                 # 004fffbc
    fadd dword ptr [eax + field_74]              # 004fffc0
    fcompp                                       # 004fffc3
    fnstsw ax                                    # 004fffc5
    test ah, 0x41                                # 004fffc7
    jne.d8 L_004fffe1                            # 004fffca
L_004fffcc:
    # block 0x004fffcc: entered by jl at 0x004fff77; fall-through of jne at 0x004fffca, 8 instruction(s), ends with jl to 0x004fff73 (backward)
    mov eax, dword ptr [esp + stk_48]            # 004fffcc
    inc ebp                                      # 004fffd0
    {load} add eax, ecx                          # 004fffd1
    {load} add edi, edx                          # 004fffd3
    mov dword ptr [esp + stk_48], eax            # 004fffd5
    mov eax, dword ptr [esp + stk_44]            # 004fffd9
    {load} cmp ebp, eax                          # 004fffdd
    jl.d8 L_004fff73                             # 004fffdf
L_004fffe1:
    # block 0x004fffe1: entered by jge at 0x004fff52; jne at 0x004fffca; fall-through of jl at 0x004fffdf, 15 instruction(s), ends with jl to 0x004ffe5f (backward)
    mov eax, dword ptr [esp + stk_10]            # 004fffe1
    mov edi, dword ptr [esi + field_18]          # 004fffe5
    shl eax, 0x10                                # 004fffe8
    {load} add eax, ebp                          # 004fffeb
    mov dword ptr [edi + 4*ebx], eax             # 004fffed
    mov eax, dword ptr [esp + stk_38]            # 004ffff0
    mov edi, dword ptr [esp + stk_40]            # 004ffff4
    {load} add eax, edx                          # 004ffff8
    mov dword ptr [esp + stk_38], eax            # 004ffffa
    mov eax, dword ptr [esp + stk_44]            # 004ffffe
    inc ebx                                      # 00500002
    {load} add edi, ecx                          # 00500003
    {load} cmp ebx, eax                          # 00500005
    mov dword ptr [esp + stk_40], edi            # 00500007
    jl.d32 L_004ffe5f                            # 0050000b
    # block 0x00500011: entered by fall-through of jl at 0x0050000b, 1 instruction(s), falls into the block at 0x00500013
    {load} mov edi, eax                          # 00500011
L_00500013:
    # block 0x00500013: entered by jle at 0x004ffe40, 4 instruction(s), ends with jle to 0x00500077 (forward)
    {load} xor ebx, ebx                          # 00500013
    test edi, edi                                # 00500015
    mov dword ptr [esp + stk_44], ebx            # 00500017
    jle.d8 L_00500077                            # 0050001b
L_0050001d:
    # block 0x0050001d: entered by jl at 0x00500075; fall-through of jle at 0x0050001b, 25 instruction(s), calls FUN_0050ce04, ends with jl to 0x0050001d (backward)
    fild dword ptr [esp + stk_44]                # 0050001d
    mov ecx, dword ptr [esi + field_20]          # 00500021
    mov edx, 0x1                                 # 00500024
    inc ecx                                      # 00500029
    fadd dword ptr [0x52e5d0]                    # 0050002a
    shl edx, cl                                  # 00500030
    fmul qword ptr [esp + stk_2c]                # 00500032
    mov dword ptr [esp + stk_44], edx            # 00500036
    fmul qword ptr [0x52cac0]                    # 0050003a
    fdiv qword ptr [esp + stk_24]                # 00500040
    fldln2                                       # 00500044
    fxch st(1)                                   # 00500046
    fyl2x                                        # 00500048
    fmul qword ptr [0x52e5c8]                    # 0050004a
    fsub qword ptr [0x52e5c0]                    # 00500050
    fild dword ptr [esp + stk_44]                # 00500056
    fmulp st(1), st                              # 0050005a
    fadd qword ptr [0x52cac0]                    # 0050005c
    call FUN_0050ce04                            # 00500062
    mov ecx, dword ptr [esi + field_14]          # 00500067
    inc ebx                                      # 0050006a
    {load} cmp ebx, edi                          # 0050006b
    mov dword ptr [esp + stk_44], ebx            # 0050006d
    mov dword ptr [ecx + 4*ebx - field_minus_4], eax # 00500071
    jl.d8 L_0050001d                             # 00500075
L_00500077:
    # block 0x00500077: entered by jle at 0x0050001b; fall-through of jl at 0x00500075, 20 instruction(s), calls FUN_005001a0, FUN_0050ea90, falls into the block at 0x005000b1
    fld qword ptr [esp + stk_2c]                 # 00500077
    fmul qword ptr [0x52cac0]                    # 0050007b
    mov eax, dword ptr [esp + stk_3c]            # 00500081
    fdiv qword ptr [esp + stk_24]                # 00500085
    mov edx, dword ptr [eax + field_1c]          # 00500089
    mov ecx, dword ptr [eax + field_18]          # 0050008c
    push edx                                     # 0050008f
    push ecx                                     # 00500090
    push edi                                     # 00500091
    push ecx                                     # 00500092
    add eax, 0x24                                # 00500093
    fstp dword ptr [esp]                         # 00500096
    push eax                                     # 00500099
    call FUN_005001a0                            # 0050009a
    push 0xc                                     # 0050009f
    mov dword ptr [esi + field_8], eax           # 005000a1
    call FUN_0050ea90                            # 005000a4
    add esp, 0x18                                # 005000a9
    mov dword ptr [esi + field_c], eax           # 005000ac
    {load} xor ebx, ebx                          # 005000af
L_005000b1:
    # block 0x005000b1: entered by jl at 0x005000ce, 9 instruction(s), calls FUN_0050ea90, ends with jl to 0x005000b1 (backward)
    lea eax, [4*edi]                             # 005000b1
    push eax                                     # 005000b8
    call FUN_0050ea90                            # 005000b9
    mov edx, dword ptr [esi + field_c]           # 005000be
    add ebx, 0x4                                 # 005000c1
    add esp, 0x4                                 # 005000c4
    cmp ebx, 0xc                                 # 005000c7
    mov dword ptr [edx + ebx - field_minus_4], eax # 005000ca
    jl.d8 L_005000b1                             # 005000ce
    # block 0x005000d0: entered by fall-through of jl at 0x005000ce, 4 instruction(s), ends with jle to 0x0050018c (forward)
    {load} xor ebx, ebx                          # 005000d0
    test edi, edi                                # 005000d2
    mov dword ptr [esp + stk_44], ebx            # 005000d4
    jle.d32 L_0050018c                           # 005000d8
    # block 0x005000de: entered by fall-through of jle at 0x005000d8, 2 instruction(s), falls into the block at 0x005000e4
    fld qword ptr [esp + stk_24]                 # 005000de
    .insn 0xdc, 0xc0                             # 005000e2
L_005000e4:
    # block 0x005000e4: entered by jl at 0x00500184, 14 instruction(s), ends with je to 0x0050011f (forward)
    fild dword ptr [esp + stk_44]                # 005000e4
    fadd qword ptr [0x52cac0]                    # 005000e8
    fmul qword ptr [esp + stk_2c]                # 005000ee
    fdiv st, st(1)                               # 005000f2
    fldln2                                       # 005000f4
    fxch st(1)                                   # 005000f6
    fyl2x                                        # 005000f8
    fmul qword ptr [0x52e5c8]                    # 005000fa
    fsub qword ptr [0x52e5c0]                    # 00500100
    .insn 0xdc, 0xc0                             # 00500106
    fcom dword ptr [0x52db78]                    # 00500108
    fnstsw ax                                    # 0050010e
    test ah, 0x1                                 # 00500110
    je.d8 L_0050011f                             # 00500113
    # block 0x00500115: entered by fall-through of je at 0x00500113, 3 instruction(s), ends with forward jump to 0x00500134
    fstp st(0)                                   # 00500115
    fld dword ptr [0x52db78]                     # 00500117
    jmp.d8 L_00500134                            # 0050011d
L_0050011f:
    # block 0x0050011f: entered by je at 0x00500113, 4 instruction(s), ends with jne to 0x00500134 (forward)
    fcom dword ptr [0x52e584]                    # 0050011f
    fnstsw ax                                    # 00500125
    test ah, 0x1                                 # 00500127
    jne.d8 L_00500134                            # 0050012a
    # block 0x0050012c: entered by fall-through of jne at 0x0050012a, 2 instruction(s), falls into the block at 0x00500134
    fstp st(0)                                   # 0050012c
    fld dword ptr [0x52e584]                     # 0050012e
L_00500134:
    # block 0x00500134: entered by jmp at 0x0050011d; jne at 0x0050012a, 8 instruction(s), calls FUN_0050ce04, falls into the block at 0x00500154
    fld st(0)                                    # 00500134
    call FUN_0050ce04                            # 00500136
    mov dword ptr [esp + stk_44], eax            # 0050013b
    {load} xor ecx, ecx                          # 0050013f
    fisub dword ptr [esp + stk_44]               # 00500141
    lea eax, [4*eax + field_88]                  # 00500145
    fld st(0)                                    # 0050014c
    fsubr qword ptr [0x52c598]                   # 0050014e
L_00500154:
    # block 0x00500154: entered by jl at 0x00500177, 13 instruction(s), ends with jl to 0x00500154 (backward)
    mov edx, dword ptr [esi + field_4]           # 00500154
    add ecx, 0x4                                 # 00500157
    fld dword ptr [edx + eax - field_minus_4]    # 0050015a
    fmul st, st(1)                               # 0050015e
    fld st(2)                                    # 00500160
    fmul dword ptr [edx + eax]                   # 00500162
    mov edx, dword ptr [esi + field_c]           # 00500165
    add eax, 0x44                                # 00500168
    cmp ecx, 0xc                                 # 0050016b
    mov edx, dword ptr [edx + ecx - field_minus_4] # 0050016e
    faddp st(1), st                              # 00500172
    fstp dword ptr [edx + 4*ebx]                 # 00500174
    jl.d8 L_00500154                             # 00500177
    # block 0x00500179: entered by fall-through of jl at 0x00500177, 6 instruction(s), ends with jl to 0x005000e4 (backward)
    inc ebx                                      # 00500179
    fstp st(0)                                   # 0050017a
    {load} cmp ebx, edi                          # 0050017c
    mov dword ptr [esp + stk_44], ebx            # 0050017e
    fstp st(0)                                   # 00500182
    jl.d32 L_005000e4                            # 00500184
    # block 0x0050018a: entered by fall-through of jl at 0x00500184, 1 instruction(s), falls into the block at 0x0050018c
    fstp st(0)                                   # 0050018a
L_0050018c:
    # block 0x0050018c: entered by jle at 0x005000d8, 6 instruction(s), ends with ret
    pop edi                                      # 0050018c
    pop esi                                      # 0050018d
    pop ebp                                      # 0050018e
    pop ebx                                      # 0050018f
    add esp, 0x24                                # 00500190
    ret                                          # 00500193

# --- data items (not part of the function) -------------------------
.org 0x00500194 - 0x401000
PAD_00500194:  # 12 byte(s) of nop padding
    .fill 12, 1, 0x90

