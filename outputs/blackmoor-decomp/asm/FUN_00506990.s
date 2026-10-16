# FUN_00506990
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00506990
# extent:       0x00506990-0x00507305 (2421 code bytes)
# span:         0x00506990-0x00507310 (code 2421, tables 0, padding 11)
# sha256:       31533c612315399821f72b543376cad76d136bf4d00939eaf22ff835f792df1f
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00506990
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       28 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 16 more
# fields:       [eax + n] field_4, field_c, field_30, field_34, field_38, field_64, field_1f4, field_220, field_404, field_484; [ebx + n] field_4, field_8, field_520, field_b34; [ecx + n] field_1, field_4, field_14, field_1c, field_30, field_34, field_38, field_320, field_404, field_484; [edi + n] field_4, field_1c; [edx + n] field_4, field_18, field_1c, field_2c, field_30, field_404; [esi + n] field_4, field_18, field_1c, field_20, field_24, field_28, field_40, field_68
# callees:      calls FUN_0050c920, FUN_004fee30, FUN_00507310, FUN_00505260, FUN_00506180, FUN_00503c00, FUN_00500ac0, FUN_005011b0, FUN_005016a0, FUN_00509230, FUN_00503b80, FUN_00509da0, FUN_00501730, FUN_005019e0, FUN_00501b70, FUN_0050bc80 and 6 more; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 877 instruction(s), 32 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ local_78, 0x78  # offset -0x78
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_40, 0x40  # offset +0x40
.equ field_64, 0x64  # offset +0x64
.equ field_68, 0x68  # offset +0x68
.equ field_1f4, 0x1f4  # offset +0x1f4
.equ field_220, 0x220  # offset +0x220
.equ field_320, 0x320  # offset +0x320
.equ field_404, 0x404  # offset +0x404
.equ field_484, 0x484  # offset +0x484
.equ field_520, 0x520  # offset +0x520
.equ field_b34, 0xb34  # offset +0xb34

# --- external targets -----------------------------------------------
.set FUN_004fee30, .text + (0x004fee30 - 0x401000)
.set FUN_00500a60, .text + (0x00500a60 - 0x401000)
.set FUN_00500ac0, .text + (0x00500ac0 - 0x401000)
.set FUN_005011b0, .text + (0x005011b0 - 0x401000)
.set FUN_005016a0, .text + (0x005016a0 - 0x401000)
.set FUN_00501730, .text + (0x00501730 - 0x401000)
.set FUN_005019e0, .text + (0x005019e0 - 0x401000)
.set FUN_00501b70, .text + (0x00501b70 - 0x401000)
.set FUN_00501c40, .text + (0x00501c40 - 0x401000)
.set FUN_00501eb0, .text + (0x00501eb0 - 0x401000)
.set FUN_00503b80, .text + (0x00503b80 - 0x401000)
.set FUN_00503c00, .text + (0x00503c00 - 0x401000)
.set FUN_00505260, .text + (0x00505260 - 0x401000)
.set FUN_00506180, .text + (0x00506180 - 0x401000)
.set FUN_00507310, .text + (0x00507310 - 0x401000)
.set FUN_00509230, .text + (0x00509230 - 0x401000)
.set FUN_00509da0, .text + (0x00509da0 - 0x401000)
.set FUN_00509e50, .text + (0x00509e50 - 0x401000)
.set FUN_0050bc00, .text + (0x0050bc00 - 0x401000)
.set FUN_0050bc80, .text + (0x0050bc80 - 0x401000)
.set FUN_0050bf30, .text + (0x0050bf30 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)

.org 0x00506990 - 0x401000
.globl FUN_00506990
FUN_00506990:
    # block 0x00506990: entry, 72 instruction(s), calls FUN_0050c920, FUN_004fee30, ends with jle to 0x00506bd5 (forward)
    push ebp                                     # 00506990
    {load} mov ebp, esp                          # 00506991
    sub esp, 0x6c                                # 00506993
    push ebx                                     # 00506996
    push esi                                     # 00506997
    mov esi, dword ptr [ebp + arg_8]             # 00506998
    push edi                                     # 0050699b
    mov eax, dword ptr [esi + field_40]          # 0050699c
    mov edi, dword ptr [eax + field_4]           # 0050699f
    mov edx, dword ptr [eax + field_64]          # 005069a2
    mov eax, dword ptr [esi + field_68]          # 005069a5
    mov dword ptr [ebp - local_10], edi          # 005069a8
    mov ebx, dword ptr [edi + field_4]           # 005069ab
    mov ecx, dword ptr [edi + field_1c]          # 005069ae
    shl ebx, 0x2                                 # 005069b1
    mov dword ptr [ebp - local_40], eax          # 005069b4
    {load} mov eax, ebx                          # 005069b7
    mov dword ptr [ebp - local_14], ecx          # 005069b9
    mov ecx, dword ptr [esi + field_24]          # 005069bc
    add eax, 0x3                                 # 005069bf
    mov dword ptr [ebp - local_8], edx           # 005069c2
    and al, -0x4                                 # 005069c5
    mov dword ptr [ebp - local_20], ecx          # 005069c7
    call FUN_0050c920                            # 005069ca
    mov dword ptr [ebp - local_48], esp          # 005069cf
    push ebx                                     # 005069d2
    push esi                                     # 005069d3
    call FUN_004fee30                            # 005069d4
    mov edx, dword ptr [edi + field_4]           # 005069d9
    mov dword ptr [ebp - local_28], eax          # 005069dc
    shl edx, 0x2                                 # 005069df
    push edx                                     # 005069e2
    push esi                                     # 005069e3
    call FUN_004fee30                            # 005069e4
    mov dword ptr [ebp - local_58], eax          # 005069e9
    mov eax, dword ptr [edi + field_4]           # 005069ec
    shl eax, 0x2                                 # 005069ef
    push eax                                     # 005069f2
    push esi                                     # 005069f3
    call FUN_004fee30                            # 005069f4
    mov ebx, dword ptr [ebp - local_40]          # 005069f9
    mov dword ptr [ebp - local_44], eax          # 005069fc
    mov eax, dword ptr [edi + field_4]           # 005069ff
    add esp, 0x18                                # 00506a02
    mov ecx, dword ptr [ebx + field_4]           # 00506a05
    shl eax, 0x2                                 # 00506a08
    add eax, 0x3                                 # 00506a0b
    mov dword ptr [ebp - local_38], ecx          # 00506a0e
    and al, -0x4                                 # 00506a11
    call FUN_0050c920                            # 00506a13
    mov edx, dword ptr [esi + field_1c]          # 00506a18
    mov eax, dword ptr [ebp - local_14]          # 00506a1b
    {load} mov ecx, esp                          # 00506a1e
    mov dword ptr [ebp - local_54], edx          # 00506a20
    mov eax, dword ptr [eax + 4*edx + field_220] # 00506a23
    mov dword ptr [ebp - local_5c], ecx          # 00506a2a
    mov dword ptr [ebp - local_4], eax           # 00506a2d
    {load} mov eax, edx                          # 00506a30
    neg eax                                      # 00506a32
    {load} sbb eax, eax                          # 00506a34
    mov dword ptr [ebp + arg_8], 0x0             # 00506a36
    and eax, 0x2                                 # 00506a3d
    add eax, dword ptr [ebx + field_8]           # 00506a40
    lea ebx, [eax + 2*eax]                       # 00506a43
    mov eax, dword ptr [ebp - local_8]           # 00506a46
    shl ebx, 0x4                                 # 00506a49
    add ebx, dword ptr [eax + field_38]          # 00506a4c
    mov dword ptr [esi + field_28], edx          # 00506a4f
    mov eax, dword ptr [edi + field_4]           # 00506a52
    test eax, eax                                # 00506a55
    mov dword ptr [ebp - local_c], ebx           # 00506a57
    jle.d32 L_00506bd5                           # 00506a5a
    # block 0x00506a60: entered by fall-through of jle at 0x00506a5a, 14 instruction(s), ends with forward jump to 0x00506a8a
    fild dword ptr [ebp - local_20]              # 00506a60
    mov eax, dword ptr [ebp - local_20]          # 00506a63
    mov dword ptr [ebp - local_1c], ecx          # 00506a66
    cdq                                          # 00506a69
    fdivr dword ptr [0x52e628]                   # 00506a6a
    {load} sub eax, edx                          # 00506a70
    mov edx, dword ptr [ebp - local_28]          # 00506a72
    sar eax                                      # 00506a75
    shl eax, 0x2                                 # 00506a77
    {load} sub edx, ecx                          # 00506a7a
    mov dword ptr [ebp - local_18], eax          # 00506a7c
    mov dword ptr [ebp - local_2c], edx          # 00506a7f
    fstp dword ptr [ebp - local_50]              # 00506a82
    jmp.d8 L_00506a8a                            # 00506a85
L_00506a87:
    # block 0x00506a87: entered by jl at 0x00506bcc, 1 instruction(s), falls into the block at 0x00506a8a
    mov eax, dword ptr [ebp - local_18]          # 00506a87
L_00506a8a:
    # block 0x00506a8a: entered by jmp at 0x00506a85, 58 instruction(s), calls FUN_004fee30, FUN_00507310, FUN_00505260, FUN_00506180, FUN_00503c00, ends with jle to 0x00506b94 (forward)
    mov ecx, dword ptr [ebp - local_50]          # 00506a8a
    mov edx, dword ptr [esi]                     # 00506a8d
    mov dword ptr [ebp - local_4c], ecx          # 00506a8f
    mov ecx, dword ptr [ebp + arg_8]             # 00506a92
    push eax                                     # 00506a95
    push esi                                     # 00506a96
    mov ebx, dword ptr [edx + 4*ecx]             # 00506a97
    call FUN_004fee30                            # 00506a9a
    mov edx, dword ptr [ebp - local_2c]          # 00506a9f
    mov ecx, dword ptr [ebp - local_1c]          # 00506aa2
    mov dword ptr [edx + ecx], eax               # 00506aa5
    lea edx, [ebp - local_4c]                    # 00506aa8
    push edx                                     # 00506aab
    call FUN_00507310                            # 00506aac
    mov eax, dword ptr [esi + field_20]          # 00506ab1
    mov ecx, dword ptr [esi + field_1c]          # 00506ab4
    mov edx, dword ptr [esi + field_18]          # 00506ab7
    push eax                                     # 00506aba
    mov eax, dword ptr [ebp - local_14]          # 00506abb
    push ecx                                     # 00506abe
    mov ecx, dword ptr [ebp - local_8]           # 00506abf
    push edx                                     # 00506ac2
    fstp dword ptr [ebp - local_3c]              # 00506ac3
    push eax                                     # 00506ac6
    lea eax, [ecx + field_4]                     # 00506ac7
    push eax                                     # 00506aca
    push ebx                                     # 00506acb
    call FUN_00505260                            # 00506acc
    mov edx, dword ptr [ebp - local_2c]          # 00506ad1
    mov eax, dword ptr [ebp - local_1c]          # 00506ad4
    mov ecx, dword ptr [edx + eax]               # 00506ad7
    mov edx, dword ptr [esi + field_1c]          # 00506ada
    mov eax, dword ptr [ebp - local_8]           # 00506add
    push ecx                                     # 00506ae0
    push ebx                                     # 00506ae1
    mov ecx, dword ptr [eax + 4*edx + field_c]   # 00506ae2
    mov edx, dword ptr [ecx]                     # 00506ae6
    push edx                                     # 00506ae8
    call FUN_00506180                            # 00506ae9
    mov eax, dword ptr [esi + field_1c]          # 00506aee
    mov ecx, dword ptr [ebp - local_8]           # 00506af1
    push ebx                                     # 00506af4
    lea eax, [eax + 2*eax]                       # 00506af5
    lea edx, [ecx + 4*eax + field_14]            # 00506af8
    push edx                                     # 00506afc
    call FUN_00503c00                            # 00506afd
    push ebx                                     # 00506b02
    call FUN_00507310                            # 00506b03
    fadd dword ptr [ebp - local_3c]              # 00506b08
    mov eax, dword ptr [ebp - local_20]          # 00506b0b
    mov ecx, dword ptr [ebp - local_1c]          # 00506b0e
    add esp, 0x3c                                # 00506b11
    dec eax                                      # 00506b14
    cmp eax, 0x1                                 # 00506b15
    mov dword ptr [ebp - local_30], 0x1          # 00506b18
    fst dword ptr [ebx]                          # 00506b1f
    fstp dword ptr [ecx]                         # 00506b21
    jle.d8 L_00506b94                            # 00506b23
    # block 0x00506b25: entered by fall-through of jle at 0x00506b23, 3 instruction(s), ends with forward jump to 0x00506b30
    lea eax, [ebx + field_4]                     # 00506b25
    mov dword ptr [ebp - local_34], eax          # 00506b28
    jmp.d8 L_00506b30                            # 00506b2b
L_00506b2d:
    # block 0x00506b2d: entered by jl at 0x00506b8f, 1 instruction(s), falls into the block at 0x00506b30
    mov eax, dword ptr [ebp - local_34]          # 00506b2d
L_00506b30:
    # block 0x00506b30: entered by jmp at 0x00506b2b, 26 instruction(s), calls FUN_00507310, ends with jne to 0x00506b78 (forward)
    fld dword ptr [eax + field_4]                # 00506b30
    fld dword ptr [eax]                          # 00506b33
    fld st(1)                                    # 00506b35
    fmul st, st(2)                               # 00506b37
    fld st(1)                                    # 00506b39
    fmul st, st(2)                               # 00506b3b
    lea ecx, [ebp - local_24]                    # 00506b3d
    push ecx                                     # 00506b40
    faddp st(1), st                              # 00506b41
    fstp dword ptr [ebp - local_24]              # 00506b43
    fstp st(0)                                   # 00506b46
    fstp st(0)                                   # 00506b48
    call FUN_00507310                            # 00506b4a
    fmul dword ptr [0x52cd14]                    # 00506b4f
    mov ecx, dword ptr [ebp - local_30]          # 00506b55
    add esp, 0x4                                 # 00506b58
    fadd dword ptr [ebp - local_3c]              # 00506b5b
    lea edx, [ecx + field_1]                     # 00506b5e
    sar edx                                      # 00506b61
    fst dword ptr [ebx + 4*edx]                  # 00506b63
    mov edx, dword ptr [ebp - local_1c]          # 00506b66
    fld st(0)                                    # 00506b69
    fcomp dword ptr [edx]                        # 00506b6b
    fnstsw ax                                    # 00506b6d
    test ah, 0x41                                # 00506b6f
    jne.d8 L_00506b78                            # 00506b72
    # block 0x00506b74: entered by fall-through of jne at 0x00506b72, 2 instruction(s), ends with forward jump to 0x00506b7a
    fstp dword ptr [edx]                         # 00506b74
    jmp.d8 L_00506b7a                            # 00506b76
L_00506b78:
    # block 0x00506b78: entered by jne at 0x00506b72, 1 instruction(s), falls into the block at 0x00506b7a
    fstp st(0)                                   # 00506b78
L_00506b7a:
    # block 0x00506b7a: entered by jmp at 0x00506b76, 9 instruction(s), ends with jl to 0x00506b2d (backward)
    mov eax, dword ptr [ebp - local_34]          # 00506b7a
    add ecx, 0x2                                 # 00506b7d
    add eax, 0x8                                 # 00506b80
    mov dword ptr [ebp - local_30], ecx          # 00506b83
    mov dword ptr [ebp - local_34], eax          # 00506b86
    mov eax, dword ptr [ebp - local_20]          # 00506b89
    dec eax                                      # 00506b8c
    {load} cmp ecx, eax                          # 00506b8d
    jl.d8 L_00506b2d                             # 00506b8f
    # block 0x00506b91: entered by fall-through of jl at 0x00506b8f, 1 instruction(s), falls into the block at 0x00506b94
    mov ecx, dword ptr [ebp - local_1c]          # 00506b91
L_00506b94:
    # block 0x00506b94: entered by jle at 0x00506b23, 5 instruction(s), ends with jne to 0x00506ba9 (forward)
    fld dword ptr [ecx]                          # 00506b94
    fcomp dword ptr [0x52db78]                   # 00506b96
    fnstsw ax                                    # 00506b9c
    test ah, 0x41                                # 00506b9e
    jne.d8 L_00506ba9                            # 00506ba1
    # block 0x00506ba3: entered by fall-through of jne at 0x00506ba1, 1 instruction(s), falls into the block at 0x00506ba9
    mov dword ptr [ecx], 0x0                     # 00506ba3
L_00506ba9:
    # block 0x00506ba9: entered by jne at 0x00506ba1, 5 instruction(s), ends with jne to 0x00506bba (forward)
    fld dword ptr [ecx]                          # 00506ba9
    fcomp dword ptr [ebp - local_38]             # 00506bab
    fnstsw ax                                    # 00506bae
    test ah, 0x41                                # 00506bb0
    jne.d8 L_00506bba                            # 00506bb3
    # block 0x00506bb5: entered by fall-through of jne at 0x00506bb3, 2 instruction(s), falls into the block at 0x00506bba
    mov edx, dword ptr [ecx]                     # 00506bb5
    mov dword ptr [ebp - local_38], edx          # 00506bb7
L_00506bba:
    # block 0x00506bba: entered by jne at 0x00506bb3, 8 instruction(s), ends with jl to 0x00506a87 (backward)
    mov eax, dword ptr [ebp + arg_8]             # 00506bba
    add ecx, 0x4                                 # 00506bbd
    mov dword ptr [ebp - local_1c], ecx          # 00506bc0
    mov ecx, dword ptr [edi + field_4]           # 00506bc3
    inc eax                                      # 00506bc6
    {load} cmp eax, ecx                          # 00506bc7
    mov dword ptr [ebp + arg_8], eax             # 00506bc9
    jl.d32 L_00506a87                            # 00506bcc
    # block 0x00506bd2: entered by fall-through of jl at 0x00506bcc, 1 instruction(s), falls into the block at 0x00506bd5
    mov ebx, dword ptr [ebp - local_c]           # 00506bd2
L_00506bd5:
    # block 0x00506bd5: entered by jle at 0x00506a5a, 21 instruction(s), calls FUN_004fee30, ends with jle to 0x00506eae (forward)
    mov eax, dword ptr [ebp - local_20]          # 00506bd5
    cdq                                          # 00506bd8
    {load} sub eax, edx                          # 00506bd9
    sar eax                                      # 00506bdb
    mov dword ptr [ebp - local_60], eax          # 00506bdd
    shl eax, 0x2                                 # 00506be0
    push eax                                     # 00506be3
    push esi                                     # 00506be4
    mov dword ptr [ebp - local_18], eax          # 00506be5
    call FUN_004fee30                            # 00506be8
    mov dword ptr [ebp - local_34], eax          # 00506bed
    mov eax, dword ptr [ebp - local_18]          # 00506bf0
    push eax                                     # 00506bf3
    push esi                                     # 00506bf4
    call FUN_004fee30                            # 00506bf5
    mov dword ptr [ebp - local_30], eax          # 00506bfa
    mov eax, dword ptr [edi + field_4]           # 00506bfd
    add esp, 0x10                                # 00506c00
    mov dword ptr [ebp + arg_8], 0x0             # 00506c03
    test eax, eax                                # 00506c0a
    jle.d32 L_00506eae                           # 00506c0c
    # block 0x00506c12: entered by fall-through of jle at 0x00506c0c, 12 instruction(s), ends with forward jump to 0x00506c38
    mov ecx, dword ptr [ebp - local_4]           # 00506c12
    mov ebx, dword ptr [ebp - local_44]          # 00506c15
    mov eax, dword ptr [ebp - local_5c]          # 00506c18
    add ecx, 0x4                                 # 00506c1b
    mov dword ptr [ebp - local_3c], ecx          # 00506c1e
    mov ecx, dword ptr [ebp - local_28]          # 00506c21
    {load} mov edx, ebx                          # 00506c24
    {load} sub ecx, eax                          # 00506c26
    {load} sub eax, edx                          # 00506c28
    mov dword ptr [ebp - local_2c], ecx          # 00506c2a
    mov dword ptr [ebp - local_50], eax          # 00506c2d
    jmp.d8 L_00506c38                            # 00506c30
L_00506c32:
    # block 0x00506c32: entered by jl at 0x00506ea3, 2 instruction(s), falls into the block at 0x00506c38
    mov ecx, dword ptr [ebp - local_2c]          # 00506c32
    mov eax, dword ptr [ebp - local_50]          # 00506c35
L_00506c38:
    # block 0x00506c38: entered by jmp at 0x00506c30, 27 instruction(s), calls FUN_004fee30, ends with jle to 0x00506cac (forward)
    mov edx, dword ptr [ebp - local_3c]          # 00506c38
    {load} add eax, ebx                          # 00506c3b
    push 0x3c                                    # 00506c3d
    push esi                                     # 00506c3f
    mov edx, dword ptr [edx]                     # 00506c40
    mov eax, dword ptr [eax + ecx]               # 00506c42
    mov ecx, dword ptr [esi]                     # 00506c45
    mov dword ptr [ebp - local_24], edx          # 00506c47
    mov edx, dword ptr [ebp + arg_8]             # 00506c4a
    mov dword ptr [ebp - local_5c], eax          # 00506c4d
    mov eax, dword ptr [ecx + 4*edx]             # 00506c50
    mov ecx, dword ptr [ebp - local_18]          # 00506c53
    mov edx, dword ptr [ebp - local_54]          # 00506c56
    {load} add ecx, eax                          # 00506c59
    mov dword ptr [ebp - local_64], eax          # 00506c5b
    mov dword ptr [ebp - local_1c], ecx          # 00506c5e
    mov dword ptr [esi + field_28], edx          # 00506c61
    call FUN_004fee30                            # 00506c64
    {load} mov edi, eax                          # 00506c69
    mov ecx, 0xf                                 # 00506c6b
    {load} xor eax, eax                          # 00506c70
    mov dword ptr [ebx], edi                     # 00506c72
    rep stosd dword ptr es:[edi], eax            # 00506c74
    mov eax, dword ptr [ebp - local_60]          # 00506c76
    add esp, 0x8                                 # 00506c79
    test eax, eax                                # 00506c7c
    jle.d8 L_00506cac                            # 00506c7e
    # block 0x00506c80: entered by fall-through of jle at 0x00506c7e, 6 instruction(s), ends with forward jump to 0x00506c93
    mov edi, dword ptr [ebp - local_1c]          # 00506c80
    mov ecx, dword ptr [ebp - local_5c]          # 00506c83
    {load} sub ecx, edi                          # 00506c86
    mov dword ptr [ebp - local_4c], eax          # 00506c88
    mov dword ptr [ebp - local_5c], ecx          # 00506c8b
    jmp.d8 L_00506c93                            # 00506c8e
L_00506c90:
    # block 0x00506c90: entered by jne at 0x00506caa, 1 instruction(s), falls into the block at 0x00506c93
    mov ecx, dword ptr [ebp - local_5c]          # 00506c90
L_00506c93:
    # block 0x00506c93: entered by jmp at 0x00506c8e, 10 instruction(s), calls FUN_00507310, ends with jne to 0x00506c90 (backward)
    {load} add ecx, edi                          # 00506c93
    push ecx                                     # 00506c95
    call FUN_00507310                            # 00506c96
    fstp dword ptr [edi]                         # 00506c9b
    mov eax, dword ptr [ebp - local_4c]          # 00506c9d
    add esp, 0x4                                 # 00506ca0
    add edi, 0x4                                 # 00506ca3
    dec eax                                      # 00506ca6
    mov dword ptr [ebp - local_4c], eax          # 00506ca7
    jne.d8 L_00506c90                            # 00506caa
L_00506cac:
    # block 0x00506cac: entered by jle at 0x00506c7e; fall-through of jne at 0x00506caa, 36 instruction(s), calls FUN_00500ac0, FUN_005011b0, FUN_005016a0, ends with jne to 0x00506f8a (forward)
    mov eax, dword ptr [ebp - local_34]          # 00506cac
    mov ecx, dword ptr [ebp - local_1c]          # 00506caf
    mov edx, dword ptr [ebp - local_c]           # 00506cb2
    push eax                                     # 00506cb5
    push ecx                                     # 00506cb6
    push edx                                     # 00506cb7
    call FUN_00500ac0                            # 00506cb8
    mov eax, dword ptr [ebp - local_50]          # 00506cbd
    mov edx, dword ptr [ebp - local_38]          # 00506cc0
    mov edi, dword ptr [ebp - local_64]          # 00506cc3
    {load} add eax, ebx                          # 00506cc6
    mov ecx, dword ptr [eax]                     # 00506cc8
    mov eax, dword ptr [ebp - local_30]          # 00506cca
    push ecx                                     # 00506ccd
    mov ecx, dword ptr [ebp - local_c]           # 00506cce
    push edx                                     # 00506cd1
    push eax                                     # 00506cd2
    push edi                                     # 00506cd3
    push ecx                                     # 00506cd4
    call FUN_005011b0                            # 00506cd5
    mov edx, dword ptr [ebp - local_30]          # 00506cda
    mov eax, dword ptr [ebp - local_34]          # 00506cdd
    mov ecx, dword ptr [ebp - local_c]           # 00506ce0
    push edi                                     # 00506ce3
    push 0x1                                     # 00506ce4
    push edx                                     # 00506ce6
    push eax                                     # 00506ce7
    push ecx                                     # 00506ce8
    call FUN_005016a0                            # 00506ce9
    mov edx, dword ptr [ebp - local_4]           # 00506cee
    mov eax, dword ptr [ebp - local_24]          # 00506cf1
    mov ecx, dword ptr [ebp - local_14]          # 00506cf4
    add esp, 0x34                                # 00506cf7
    mov eax, dword ptr [edx + 4*eax + field_404] # 00506cfa
    cmp dword ptr [ecx + 4*eax + field_320], 0x1 # 00506d01
    jne.d32 L_00506f8a                           # 00506d09
    # block 0x00506d0f: entered by fall-through of jne at 0x00506d09, 16 instruction(s), calls FUN_00509230, FUN_00503b80, ends with je to 0x00506e8a (forward)
    mov edx, dword ptr [ebp - local_1c]          # 00506d0f
    mov ecx, dword ptr [ebp - local_8]           # 00506d12
    push edi                                     # 00506d15
    push edx                                     # 00506d16
    mov edx, dword ptr [ecx + field_30]          # 00506d17
    mov eax, dword ptr [edx + 4*eax]             # 00506d1a
    push eax                                     # 00506d1d
    push esi                                     # 00506d1e
    call FUN_00509230                            # 00506d1f
    mov ecx, dword ptr [ebx]                     # 00506d24
    push esi                                     # 00506d26
    mov dword ptr [ecx + field_1c], eax          # 00506d27
    call FUN_00503b80                            # 00506d2a
    add esp, 0x14                                # 00506d2f
    test eax, eax                                # 00506d32
    je.d32 L_00506e8a                            # 00506d34
    # block 0x00506d3a: entered by fall-through of je at 0x00506d34, 4 instruction(s), ends with je to 0x00506e8a (forward)
    mov edx, dword ptr [ebx]                     # 00506d3a
    mov eax, dword ptr [edx + field_1c]          # 00506d3c
    test eax, eax                                # 00506d3f
    je.d32 L_00506e8a                            # 00506d41
    # block 0x00506d47: entered by fall-through of je at 0x00506d41, 49 instruction(s), calls FUN_005016a0, FUN_00509230, falls into the block at 0x00506dcb
    mov eax, dword ptr [ebp - local_30]          # 00506d47
    mov ecx, dword ptr [ebp - local_34]          # 00506d4a
    mov edx, dword ptr [ebp - local_c]           # 00506d4d
    push edi                                     # 00506d50
    push 0x2                                     # 00506d51
    push eax                                     # 00506d53
    push ecx                                     # 00506d54
    push edx                                     # 00506d55
    call FUN_005016a0                            # 00506d56
    mov eax, dword ptr [ebp - local_1c]          # 00506d5b
    mov ecx, dword ptr [ebp - local_4]           # 00506d5e
    mov edx, dword ptr [ebp - local_24]          # 00506d61
    push edi                                     # 00506d64
    push eax                                     # 00506d65
    mov eax, dword ptr [ecx + 4*edx + field_404] # 00506d66
    mov ecx, dword ptr [ebp - local_8]           # 00506d6d
    mov edx, dword ptr [ecx + field_30]          # 00506d70
    mov eax, dword ptr [edx + 4*eax]             # 00506d73
    push eax                                     # 00506d76
    push esi                                     # 00506d77
    call FUN_00509230                            # 00506d78
    mov ecx, dword ptr [ebx]                     # 00506d7d
    mov edx, dword ptr [ebp - local_30]          # 00506d7f
    push edi                                     # 00506d82
    push 0x0                                     # 00506d83
    mov dword ptr [ecx + field_38], eax          # 00506d85
    mov eax, dword ptr [ebp - local_34]          # 00506d88
    mov ecx, dword ptr [ebp - local_c]           # 00506d8b
    push edx                                     # 00506d8e
    push eax                                     # 00506d8f
    push ecx                                     # 00506d90
    call FUN_005016a0                            # 00506d91
    mov edx, dword ptr [ebp - local_1c]          # 00506d96
    mov eax, dword ptr [ebp - local_4]           # 00506d99
    mov ecx, dword ptr [ebp - local_24]          # 00506d9c
    push edi                                     # 00506d9f
    push edx                                     # 00506da0
    mov edx, dword ptr [eax + 4*ecx + field_404] # 00506da1
    mov eax, dword ptr [ebp - local_8]           # 00506da8
    mov ecx, dword ptr [eax + field_30]          # 00506dab
    mov edx, dword ptr [ecx + 4*edx]             # 00506dae
    push edx                                     # 00506db1
    push esi                                     # 00506db2
    call FUN_00509230                            # 00506db3
    mov ecx, dword ptr [ebx]                     # 00506db8
    add esp, 0x48                                # 00506dba
    mov dword ptr [ebp - local_4c], 0x4          # 00506dbd
    mov edi, 0x10000                             # 00506dc4
    mov dword ptr [ecx], eax                     # 00506dc9
L_00506dcb:
    # block 0x00506dcb: entered by jl at 0x00506e22, 31 instruction(s), calls FUN_00509da0, ends with jl to 0x00506dcb (backward)
    mov eax, 0x92492493                          # 00506dcb
    mov ecx, dword ptr [ebx]                     # 00506dd0
    imul edi                                     # 00506dd2
    {load} add edx, edi                          # 00506dd4
    sar edx, 0x2                                 # 00506dd6
    {load} mov eax, edx                          # 00506dd9
    shr eax, 0x1f                                # 00506ddb
    {load} add edx, eax                          # 00506dde
    mov eax, dword ptr [ecx]                     # 00506de0
    push edx                                     # 00506de2
    mov edx, dword ptr [ecx + field_1c]          # 00506de3
    mov ecx, dword ptr [ebp - local_4]           # 00506de6
    push edx                                     # 00506de9
    mov edx, dword ptr [ebp - local_24]          # 00506dea
    push eax                                     # 00506ded
    mov eax, dword ptr [ecx + 4*edx + field_404] # 00506dee
    mov ecx, dword ptr [ebp - local_8]           # 00506df5
    mov edx, dword ptr [ecx + field_30]          # 00506df8
    mov eax, dword ptr [edx + 4*eax]             # 00506dfb
    push eax                                     # 00506dfe
    push esi                                     # 00506dff
    call FUN_00509da0                            # 00506e00
    mov edx, dword ptr [ebx]                     # 00506e05
    mov ecx, dword ptr [ebp - local_4c]          # 00506e07
    add edi, 0x10000                             # 00506e0a
    add esp, 0x14                                # 00506e10
    mov dword ptr [edx + ecx], eax               # 00506e13
    add ecx, 0x4                                 # 00506e16
    cmp edi, 0x70000                             # 00506e19
    mov dword ptr [ebp - local_4c], ecx          # 00506e1f
    jl.d8 L_00506dcb                             # 00506e22
    # block 0x00506e24: entered by fall-through of jl at 0x00506e22, 2 instruction(s), falls into the block at 0x00506e30
    mov dword ptr [ebp - local_4c], 0x20         # 00506e24
    mov edi, 0x10000                             # 00506e2b
L_00506e30:
    # block 0x00506e30: entered by jl at 0x00506e88, 31 instruction(s), calls FUN_00509da0, ends with jl to 0x00506e30 (backward)
    mov eax, 0x92492493                          # 00506e30
    mov ecx, dword ptr [ebx]                     # 00506e35
    imul edi                                     # 00506e37
    {load} add edx, edi                          # 00506e39
    sar edx, 0x2                                 # 00506e3b
    {load} mov eax, edx                          # 00506e3e
    shr eax, 0x1f                                # 00506e40
    {load} add edx, eax                          # 00506e43
    mov eax, dword ptr [ecx + field_1c]          # 00506e45
    push edx                                     # 00506e48
    mov edx, dword ptr [ecx + field_38]          # 00506e49
    mov ecx, dword ptr [ebp - local_4]           # 00506e4c
    push edx                                     # 00506e4f
    mov edx, dword ptr [ebp - local_24]          # 00506e50
    push eax                                     # 00506e53
    mov eax, dword ptr [ecx + 4*edx + field_404] # 00506e54
    mov ecx, dword ptr [ebp - local_8]           # 00506e5b
    mov edx, dword ptr [ecx + field_30]          # 00506e5e
    mov eax, dword ptr [edx + 4*eax]             # 00506e61
    push eax                                     # 00506e64
    push esi                                     # 00506e65
    call FUN_00509da0                            # 00506e66
    mov edx, dword ptr [ebx]                     # 00506e6b
    mov ecx, dword ptr [ebp - local_4c]          # 00506e6d
    add edi, 0x10000                             # 00506e70
    add esp, 0x14                                # 00506e76
    mov dword ptr [edx + ecx], eax               # 00506e79
    add ecx, 0x4                                 # 00506e7c
    cmp edi, 0x70000                             # 00506e7f
    mov dword ptr [ebp - local_4c], ecx          # 00506e85
    jl.d8 L_00506e30                             # 00506e88
L_00506e8a:
    # block 0x00506e8a: entered by je at 0x00506d34; je at 0x00506d41; fall-through of jl at 0x00506e88, 10 instruction(s), ends with jl to 0x00506c32 (backward)
    mov ecx, dword ptr [ebp - local_3c]          # 00506e8a
    mov eax, dword ptr [ebp + arg_8]             # 00506e8d
    add ecx, 0x4                                 # 00506e90
    inc eax                                      # 00506e93
    mov dword ptr [ebp - local_3c], ecx          # 00506e94
    mov ecx, dword ptr [ebp - local_10]          # 00506e97
    add ebx, 0x4                                 # 00506e9a
    mov dword ptr [ebp + arg_8], eax             # 00506e9d
    cmp eax, dword ptr [ecx + field_4]           # 00506ea0
    jl.d32 L_00506c32                            # 00506ea3
    # block 0x00506ea9: entered by fall-through of jl at 0x00506ea3, 2 instruction(s), falls into the block at 0x00506eae
    mov ebx, dword ptr [ebp - local_c]           # 00506ea9
    {load} mov edi, ecx                          # 00506eac
L_00506eae:
    # block 0x00506eae: entered by jle at 0x00506c0c, 30 instruction(s), calls FUN_0050c920, ends with je to 0x00506f3a (forward)
    mov eax, dword ptr [ebp - local_40]          # 00506eae
    mov edx, dword ptr [ebp - local_38]          # 00506eb1
    mov dword ptr [eax + field_4], edx           # 00506eb4
    mov eax, dword ptr [edi + field_4]           # 00506eb7
    shl eax, 0x2                                 # 00506eba
    mov dword ptr [ebp + arg_8], eax             # 00506ebd
    add eax, 0x3                                 # 00506ec0
    and al, -0x4                                 # 00506ec3
    call FUN_0050c920                            # 00506ec5
    mov eax, dword ptr [ebp + arg_8]             # 00506eca
    mov dword ptr [ebp - local_6c], esp          # 00506ecd
    add eax, 0x3                                 # 00506ed0
    and al, -0x4                                 # 00506ed3
    call FUN_0050c920                            # 00506ed5
    mov eax, dword ptr [ebp + arg_8]             # 00506eda
    mov dword ptr [ebp - local_34], esp          # 00506edd
    add eax, 0x3                                 # 00506ee0
    and al, -0x4                                 # 00506ee3
    call FUN_0050c920                            # 00506ee5
    mov eax, dword ptr [ebp + arg_8]             # 00506eea
    mov dword ptr [ebp - local_3c], esp          # 00506eed
    add eax, 0x3                                 # 00506ef0
    and al, -0x4                                 # 00506ef3
    call FUN_0050c920                            # 00506ef5
    mov eax, dword ptr [ebp - local_4]           # 00506efa
    {load} mov edx, esp                          # 00506efd
    mov dword ptr [ebp - local_50], edx          # 00506eff
    mov ecx, dword ptr [eax + field_484]         # 00506f02
    test ecx, ecx                                # 00506f08
    je.d8 L_00506f3a                             # 00506f0a
    # block 0x00506f0c: entered by fall-through of je at 0x00506f0a, 19 instruction(s), calls FUN_00501730, FUN_005019e0, falls into the block at 0x00506f3a
    mov ecx, dword ptr [ebp - local_28]          # 00506f0c
    mov edx, dword ptr [ebp - local_14]          # 00506f0f
    push ecx                                     # 00506f12
    push eax                                     # 00506f13
    add edx, 0xb34                               # 00506f14
    push ebx                                     # 00506f1a
    push edx                                     # 00506f1b
    push esi                                     # 00506f1c
    call FUN_00501730                            # 00506f1d
    mov dword ptr [ebp - local_68], eax          # 00506f22
    push eax                                     # 00506f25
    mov eax, dword ptr [ebp - local_4]           # 00506f26
    push eax                                     # 00506f29
    push ebx                                     # 00506f2a
    push esi                                     # 00506f2b
    call FUN_005019e0                            # 00506f2c
    mov edx, dword ptr [ebp - local_50]          # 00506f31
    add esp, 0x24                                # 00506f34
    mov dword ptr [ebp - local_1c], eax          # 00506f37
L_00506f3a:
    # block 0x00506f3a: entered by je at 0x00506f0a, 15 instruction(s), ends with je to 0x00506fd0 (forward)
    mov ecx, dword ptr [edi + field_4]           # 00506f3a
    {load} xor eax, eax                          # 00506f3d
    shl ecx, 0x2                                 # 00506f3f
    {load} mov ebx, ecx                          # 00506f42
    {load} mov edi, edx                          # 00506f44
    shr ecx, 0x2                                 # 00506f46
    rep stosd dword ptr es:[edi], eax            # 00506f49
    {load} mov ecx, ebx                          # 00506f4b
    and ecx, 0x3                                 # 00506f4d
    rep stosb byte ptr es:[edi], al              # 00506f50
    mov ecx, dword ptr [ebp - local_c]           # 00506f52
    mov eax, dword ptr [ecx + field_4]           # 00506f55
    mov ecx, dword ptr [eax + field_1f4]         # 00506f58
    test ecx, ecx                                # 00506f5e
    je.d8 L_00506fd0                             # 00506f60
    # block 0x00506f62: entered by fall-through of je at 0x00506f60, 5 instruction(s), ends with jle to 0x00506fd0 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00506f62
    mov dword ptr [ebp + arg_8], 0x0             # 00506f65
    mov eax, dword ptr [ecx + field_4]           # 00506f6c
    test eax, eax                                # 00506f6f
    jle.d8 L_00506fd0                            # 00506f71
    # block 0x00506f73: entered by fall-through of jle at 0x00506f71, 9 instruction(s), ends with forward jump to 0x00506f9d
    mov eax, dword ptr [ebp - local_20]          # 00506f73
    mov ecx, dword ptr [ebp - local_28]          # 00506f76
    shl eax, 0x2                                 # 00506f79
    shr eax                                      # 00506f7c
    {load} sub ecx, edx                          # 00506f7e
    mov dword ptr [ebp - local_64], eax          # 00506f80
    {load} mov edi, edx                          # 00506f83
    mov dword ptr [ebp - local_60], ecx          # 00506f85
    jmp.d8 L_00506f9d                            # 00506f88
L_00506f8a:
    # block 0x00506f8a: entered by jne at 0x00506d09, 8 instruction(s), ends with ret
    or eax, -0x1                                 # 00506f8a
    lea esp, [ebp - local_78]                    # 00506f8d
    pop edi                                      # 00506f90
    pop esi                                      # 00506f91
    pop ebx                                      # 00506f92
    {load} mov esp, ebp                          # 00506f93
    pop ebp                                      # 00506f95
    ret                                          # 00506f96
L_00506f97:
    # block 0x00506f97: entered by jl at 0x00506fce, 2 instruction(s), falls into the block at 0x00506f9d
    mov eax, dword ptr [ebp - local_64]          # 00506f97
    mov ecx, dword ptr [ebp - local_60]          # 00506f9a
L_00506f9d:
    # block 0x00506f9d: entered by jmp at 0x00506f88, 20 instruction(s), calls FUN_0050c920, FUN_00501b70, ends with jl to 0x00506f97 (backward)
    mov ebx, dword ptr [ecx + edi]               # 00506f9d
    add eax, 0x3                                 # 00506fa0
    and al, -0x4                                 # 00506fa3
    call FUN_0050c920                            # 00506fa5
    mov ecx, dword ptr [ebp - local_c]           # 00506faa
    {load} mov eax, esp                          # 00506fad
    push eax                                     # 00506faf
    push ebx                                     # 00506fb0
    push ecx                                     # 00506fb1
    mov dword ptr [edi], eax                     # 00506fb2
    call FUN_00501b70                            # 00506fb4
    mov edx, dword ptr [ebp - local_10]          # 00506fb9
    mov eax, dword ptr [ebp + arg_8]             # 00506fbc
    add esp, 0xc                                 # 00506fbf
    inc eax                                      # 00506fc2
    mov ecx, dword ptr [edx + field_4]           # 00506fc3
    add edi, 0x4                                 # 00506fc6
    {load} cmp eax, ecx                          # 00506fc9
    mov dword ptr [ebp + arg_8], eax             # 00506fcb
    jl.d8 L_00506f97                             # 00506fce
L_00506fd0:
    # block 0x00506fd0: entered by je at 0x00506f60; jle at 0x00506f71; fall-through of jl at 0x00506fce, 17 instruction(s), calls FUN_00503b80, ends with jg to 0x005072f9 (forward)
    push esi                                     # 00506fd0
    call FUN_00503b80                            # 00506fd1
    {load} mov edi, eax                          # 00506fd6
    push esi                                     # 00506fd8
    neg edi                                      # 00506fd9
    {load} sbb edi, edi                          # 00506fdb
    and edi, -0x7                                # 00506fdd
    add edi, 0x7                                 # 00506fe0
    mov dword ptr [ebp - local_24], edi          # 00506fe3
    call FUN_00503b80                            # 00506fe6
    add esp, 0x8                                 # 00506feb
    neg eax                                      # 00506fee
    {load} sbb eax, eax                          # 00506ff0
    and eax, 0x7                                 # 00506ff2
    add eax, 0x7                                 # 00506ff5
    {load} cmp edi, eax                          # 00506ff8
    jg.d32 L_005072f9                            # 00506ffa
    # block 0x00507000: entered by fall-through of jg at 0x00506ffa, 4 instruction(s), falls into the block at 0x0050700d
    mov eax, dword ptr [ebp - local_40]          # 00507000
    lea ebx, [esi + field_4]                     # 00507003
    lea ecx, [eax + 4*edi + field_c]             # 00507006
    mov dword ptr [ebp - local_4c], ecx          # 0050700a
L_0050700d:
    # block 0x0050700d: entered by jle at 0x005072f3, 15 instruction(s), calls FUN_0050bc80, ends with je to 0x0050704d (forward)
    push 0x1                                     # 0050700d
    push 0x0                                     # 0050700f
    push ebx                                     # 00507011
    call FUN_0050bc80                            # 00507012
    mov edx, dword ptr [ebp - local_8]           # 00507017
    mov ecx, dword ptr [ebp - local_54]          # 0050701a
    mov eax, dword ptr [edx + field_2c]          # 0050701d
    push eax                                     # 00507020
    push ecx                                     # 00507021
    push ebx                                     # 00507022
    call FUN_0050bc80                            # 00507023
    mov eax, dword ptr [esi + field_1c]          # 00507028
    add esp, 0x18                                # 0050702b
    test eax, eax                                # 0050702e
    je.d8 L_0050704d                             # 00507030
    # block 0x00507032: entered by fall-through of je at 0x00507030, 11 instruction(s), calls FUN_0050bc80, falls into the block at 0x0050704d
    mov edx, dword ptr [esi + field_18]          # 00507032
    push 0x1                                     # 00507035
    push edx                                     # 00507037
    push ebx                                     # 00507038
    call FUN_0050bc80                            # 00507039
    mov eax, dword ptr [esi + field_20]          # 0050703e
    push 0x1                                     # 00507041
    push eax                                     # 00507043
    push ebx                                     # 00507044
    call FUN_0050bc80                            # 00507045
    add esp, 0x18                                # 0050704a
L_0050704d:
    # block 0x0050704d: entered by je at 0x00507030, 5 instruction(s), ends with jle to 0x00507151 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0050704d
    mov dword ptr [ebp + arg_8], 0x0             # 00507050
    mov eax, dword ptr [ecx + field_4]           # 00507057
    test eax, eax                                # 0050705a
    jle.d32 L_00507151                           # 0050705c
    # block 0x00507062: entered by fall-through of jle at 0x0050705c, 17 instruction(s), ends with forward jump to 0x00507093
    mov edi, dword ptr [ebp - local_58]          # 00507062
    mov ecx, dword ptr [ebp - local_44]          # 00507065
    mov edx, dword ptr [ebp - local_4]           # 00507068
    mov eax, dword ptr [ebp - local_28]          # 0050706b
    {load} sub ecx, edi                          # 0050706e
    add edx, 0x4                                 # 00507070
    mov dword ptr [ebp - local_60], ecx          # 00507073
    mov ecx, dword ptr [ebp - local_48]          # 00507076
    {load} sub ecx, edi                          # 00507079
    {load} sub eax, edi                          # 0050707b
    mov dword ptr [ebp - local_38], ecx          # 0050707d
    mov ecx, dword ptr [ebp - local_50]          # 00507080
    {load} sub ecx, edi                          # 00507083
    mov dword ptr [ebp - local_40], edx          # 00507085
    mov dword ptr [ebp - local_64], eax          # 00507088
    mov dword ptr [ebp - local_20], ecx          # 0050708b
    jmp.d8 L_00507093                            # 0050708e
L_00507090:
    # block 0x00507090: entered by jl at 0x00507148, 1 instruction(s), falls into the block at 0x00507093
    mov eax, dword ptr [ebp - local_64]          # 00507090
L_00507093:
    # block 0x00507093: entered by jmp at 0x0050708e, 70 instruction(s), calls FUN_004fee30, FUN_00509e50, FUN_00500a60, FUN_00501c40, ends with jl to 0x00507090 (backward)
    mov ecx, dword ptr [ebp - local_40]          # 00507093
    mov eax, dword ptr [eax + edi]               # 00507096
    mov dword ptr [ebp - local_2c], eax          # 00507099
    mov eax, dword ptr [ebp - local_18]          # 0050709c
    mov edx, dword ptr [ecx]                     # 0050709f
    mov ecx, dword ptr [esi]                     # 005070a1
    mov dword ptr [ebp - local_5c], edx          # 005070a3
    mov edx, dword ptr [ebp + arg_8]             # 005070a6
    push eax                                     # 005070a9
    push esi                                     # 005070aa
    mov ebx, dword ptr [ecx + 4*edx]             # 005070ab
    call FUN_004fee30                            # 005070ae
    mov ecx, dword ptr [ebp - local_60]          # 005070b3
    mov dword ptr [ebp - local_30], eax          # 005070b6
    mov dword ptr [edi], eax                     # 005070b9
    push eax                                     # 005070bb
    mov edx, dword ptr [ecx + edi]               # 005070bc
    mov eax, dword ptr [ebp - local_24]          # 005070bf
    mov ecx, dword ptr [edx + 4*eax]             # 005070c2
    mov edx, dword ptr [ebp - local_4]           # 005070c5
    mov eax, dword ptr [ebp - local_5c]          # 005070c8
    push ecx                                     # 005070cb
    mov ecx, dword ptr [edx + 4*eax + field_404] # 005070cc
    mov edx, dword ptr [ebp - local_8]           # 005070d3
    mov eax, dword ptr [edx + field_30]          # 005070d6
    mov ecx, dword ptr [eax + 4*ecx]             # 005070d9
    push ecx                                     # 005070dc
    push esi                                     # 005070dd
    call FUN_00509e50                            # 005070de
    mov edx, dword ptr [ebp - local_38]          # 005070e3
    mov ecx, dword ptr [ebp - local_24]          # 005070e6
    mov dword ptr [edx + edi], eax               # 005070e9
    mov eax, dword ptr [esi + field_1c]          # 005070ec
    add eax, 0x36                                # 005070ef
    lea eax, [eax + 2*eax]                       # 005070f2
    lea edx, [ecx + 4*eax]                       # 005070f5
    mov ecx, dword ptr [ebp - local_14]          # 005070f8
    {load} add eax, edx                          # 005070fb
    mov edx, dword ptr [ecx + 4*eax]             # 005070fd
    mov eax, dword ptr [ebp - local_30]          # 00507100
    mov ecx, dword ptr [ebp - local_2c]          # 00507103
    push edx                                     # 00507106
    mov edx, dword ptr [ebp - local_c]           # 00507107
    push ebx                                     # 0050710a
    push eax                                     # 0050710b
    push ecx                                     # 0050710c
    push edx                                     # 0050710d
    call FUN_00500a60                            # 0050710e
    mov eax, dword ptr [ebp - local_20]          # 00507113
    mov edx, dword ptr [ebp - local_18]          # 00507116
    {load} add edx, ebx                          # 00507119
    mov ecx, dword ptr [eax + edi]               # 0050711b
    mov eax, dword ptr [ebp - local_c]           # 0050711e
    push ecx                                     # 00507121
    push edx                                     # 00507122
    push ebx                                     # 00507123
    push eax                                     # 00507124
    call FUN_00501c40                            # 00507125
    mov ecx, dword ptr [ebp - local_40]          # 0050712a
    mov eax, dword ptr [ebp + arg_8]             # 0050712d
    add ecx, 0x4                                 # 00507130
    add esp, 0x3c                                # 00507133
    mov dword ptr [ebp - local_40], ecx          # 00507136
    mov ecx, dword ptr [ebp - local_10]          # 00507139
    inc eax                                      # 0050713c
    add edi, 0x4                                 # 0050713d
    mov edx, dword ptr [ecx + field_4]           # 00507140
    mov dword ptr [ebp + arg_8], eax             # 00507143
    {load} cmp eax, edx                          # 00507146
    jl.d32 L_00507090                            # 00507148
    # block 0x0050714e: entered by fall-through of jl at 0x00507148, 1 instruction(s), falls into the block at 0x00507151
    mov edi, dword ptr [ebp - local_24]          # 0050714e
L_00507151:
    # block 0x00507151: entered by jle at 0x0050705c, 4 instruction(s), ends with je to 0x005071a0 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00507151
    mov eax, dword ptr [ecx + field_484]         # 00507154
    test eax, eax                                # 0050715a
    je.d8 L_005071a0                             # 0050715c
    # block 0x0050715e: entered by fall-through of je at 0x0050715c, 28 instruction(s), calls FUN_00501eb0, ends with forward jump to 0x005071a3
    mov eax, dword ptr [esi + field_1c]          # 0050715e
    mov ebx, dword ptr [ebp - local_14]          # 00507161
    add eax, 0x36                                # 00507164
    lea eax, [eax + 2*eax]                       # 00507167
    lea edx, [edi + 4*eax]                       # 0050716a
    {load} add eax, edx                          # 0050716d
    mov edx, dword ptr [ebp - local_48]          # 0050716f
    mov eax, dword ptr [ebx + 4*eax]             # 00507172
    push eax                                     # 00507175
    mov eax, dword ptr [ebp - local_58]          # 00507176
    push edx                                     # 00507179
    mov edx, dword ptr [ebp - local_1c]          # 0050717a
    push eax                                     # 0050717d
    mov eax, dword ptr [ebp - local_68]          # 0050717e
    push edx                                     # 00507181
    mov edx, dword ptr [esi]                     # 00507182
    push eax                                     # 00507184
    mov eax, dword ptr [ebp - local_c]           # 00507185
    push edx                                     # 00507188
    push ecx                                     # 00507189
    lea ecx, [ebx + field_b34]                   # 0050718a
    push eax                                     # 00507190
    push ecx                                     # 00507191
    push edi                                     # 00507192
    call FUN_00501eb0                            # 00507193
    mov ecx, dword ptr [ebp - local_4]           # 00507198
    add esp, 0x28                                # 0050719b
    jmp.d8 L_005071a3                            # 0050719e
L_005071a0:
    # block 0x005071a0: entered by je at 0x0050715c, 1 instruction(s), falls into the block at 0x005071a3
    mov ebx, dword ptr [ebp - local_14]          # 005071a0
L_005071a3:
    # block 0x005071a3: entered by jmp at 0x0050719e, 4 instruction(s), ends with jle to 0x005072c0 (forward)
    mov eax, dword ptr [ecx]                     # 005071a3
    mov dword ptr [ebp + arg_8], 0x0             # 005071a5
    test eax, eax                                # 005071ac
    jle.d32 L_005072c0                           # 005071ae
    # block 0x005071b4: entered by fall-through of jle at 0x005071ae, 2 instruction(s), falls into the block at 0x005071bd
    add ecx, 0x444                               # 005071b4
    mov dword ptr [ebp - local_30], ecx          # 005071ba
L_005071bd:
    # block 0x005071bd: entered by jl at 0x005072b7, 8 instruction(s), ends with jle to 0x0050724a (forward)
    mov edx, dword ptr [ebp - local_30]          # 005071bd
    mov eax, dword ptr [ebp - local_10]          # 005071c0
    {load} xor ecx, ecx                          # 005071c3
    mov dword ptr [ebp - local_38], 0x0          # 005071c5
    mov edi, dword ptr [edx]                     # 005071cc
    mov edx, dword ptr [eax + field_4]           # 005071ce
    test edx, edx                                # 005071d1
    jle.d8 L_0050724a                            # 005071d3
    # block 0x005071d5: entered by fall-through of jle at 0x005071d3, 10 instruction(s), falls into the block at 0x005071f1
    mov edx, dword ptr [ebp - local_4]           # 005071d5
    mov eax, dword ptr [ebp - local_3c]          # 005071d8
    add edx, 0x4                                 # 005071db
    mov dword ptr [ebp - local_40], edx          # 005071de
    mov edx, dword ptr [ebp - local_6c]          # 005071e1
    {load} sub edx, eax                          # 005071e4
    mov dword ptr [ebp - local_64], edx          # 005071e6
    mov edx, dword ptr [ebp - local_34]          # 005071e9
    {load} sub edx, eax                          # 005071ec
    mov dword ptr [ebp - local_60], edx          # 005071ee
L_005071f1:
    # block 0x005071f1: entered by jl at 0x00507245, 4 instruction(s), ends with jne to 0x00507235 (forward)
    mov ebx, dword ptr [ebp - local_40]          # 005071f1
    mov edx, dword ptr [ebp + arg_8]             # 005071f4
    cmp dword ptr [ebx], edx                     # 005071f7
    jne.d8 L_00507235                            # 005071f9
    # block 0x005071fb: entered by fall-through of jne at 0x005071f9, 4 instruction(s), ends with je to 0x00507210 (forward)
    mov edx, dword ptr [ebp - local_48]          # 005071fb
    mov dword ptr [eax], 0x0                     # 005071fe
    cmp dword ptr [edx + 4*ecx], 0x0             # 00507204
    je.d8 L_00507210                             # 00507208
    # block 0x0050720a: entered by fall-through of je at 0x00507208, 1 instruction(s), falls into the block at 0x00507210
    mov dword ptr [eax], 0x1                     # 0050720a
L_00507210:
    # block 0x00507210: entered by je at 0x00507208, 14 instruction(s), falls into the block at 0x00507235
    mov edx, dword ptr [esi]                     # 00507210
    mov ebx, dword ptr [ebp - local_64]          # 00507212
    mov edx, dword ptr [edx + 4*ecx]             # 00507215
    mov dword ptr [ebx + eax], edx               # 00507218
    mov edx, dword ptr [esi]                     # 0050721b
    mov ebx, dword ptr [ebp - local_18]          # 0050721d
    mov edx, dword ptr [edx + 4*ecx]             # 00507220
    {load} add edx, ebx                          # 00507223
    mov ebx, dword ptr [ebp - local_60]          # 00507225
    mov dword ptr [ebx + eax], edx               # 00507228
    mov ebx, dword ptr [ebp - local_38]          # 0050722b
    inc ebx                                      # 0050722e
    add eax, 0x4                                 # 0050722f
    mov dword ptr [ebp - local_38], ebx          # 00507232
L_00507235:
    # block 0x00507235: entered by jne at 0x005071f9, 7 instruction(s), ends with jl to 0x005071f1 (backward)
    mov edx, dword ptr [ebp - local_40]          # 00507235
    inc ecx                                      # 00507238
    add edx, 0x4                                 # 00507239
    mov dword ptr [ebp - local_40], edx          # 0050723c
    mov edx, dword ptr [ebp - local_10]          # 0050723f
    cmp ecx, dword ptr [edx + field_4]           # 00507242
    jl.d8 L_005071f1                             # 00507245
    # block 0x00507247: entered by fall-through of jl at 0x00507245, 1 instruction(s), falls into the block at 0x0050724a
    mov ebx, dword ptr [ebp - local_14]          # 00507247
L_0050724a:
    # block 0x0050724a: entered by jle at 0x005071d3, 41 instruction(s), calls indirect dword ptr [ecx + 0x14], indirect dword ptr [edx + 0x18], ends with jl to 0x005071bd (backward)
    mov eax, dword ptr [ebx + 4*edi + field_520] # 0050724a
    mov edx, dword ptr [ebp - local_38]          # 00507251
    push edx                                     # 00507254
    mov edx, dword ptr [ebp - local_34]          # 00507255
    mov ecx, dword ptr [4*eax + 0x5669e8]        # 00507258
    mov eax, dword ptr [ebp - local_3c]          # 0050725f
    push eax                                     # 00507262
    mov eax, dword ptr [ebp - local_8]           # 00507263
    push edx                                     # 00507266
    mov edx, dword ptr [eax + field_34]          # 00507267
    mov eax, dword ptr [edx + 4*edi]             # 0050726a
    push eax                                     # 0050726d
    push esi                                     # 0050726e
    call dword ptr [ecx + field_14]              # 0050726f
    mov ecx, dword ptr [ebx + 4*edi + field_520] # 00507272
    push eax                                     # 00507279
    mov eax, dword ptr [ebp - local_38]          # 0050727a
    mov edx, dword ptr [4*ecx + 0x5669e8]        # 0050727d
    mov ecx, dword ptr [ebp - local_3c]          # 00507284
    push eax                                     # 00507287
    mov eax, dword ptr [ebp - local_34]          # 00507288
    push ecx                                     # 0050728b
    mov ecx, dword ptr [ebp - local_8]           # 0050728c
    push 0x0                                     # 0050728f
    push eax                                     # 00507291
    mov eax, dword ptr [ecx + field_34]          # 00507292
    mov ecx, dword ptr [eax + 4*edi]             # 00507295
    push ecx                                     # 00507298
    push esi                                     # 00507299
    call dword ptr [edx + field_18]              # 0050729a
    mov edx, dword ptr [ebp - local_30]          # 0050729d
    mov eax, dword ptr [ebp + arg_8]             # 005072a0
    add edx, 0x4                                 # 005072a3
    add esp, 0x30                                # 005072a6
    mov dword ptr [ebp - local_30], edx          # 005072a9
    mov edx, dword ptr [ebp - local_4]           # 005072ac
    inc eax                                      # 005072af
    mov ecx, dword ptr [edx]                     # 005072b0
    mov dword ptr [ebp + arg_8], eax             # 005072b2
    {load} cmp eax, ecx                          # 005072b5
    jl.d32 L_005071bd                            # 005072b7
    # block 0x005072bd: entered by fall-through of jl at 0x005072b7, 1 instruction(s), falls into the block at 0x005072c0
    mov edi, dword ptr [ebp - local_24]          # 005072bd
L_005072c0:
    # block 0x005072c0: entered by jle at 0x005071ae, 20 instruction(s), calls FUN_0050bc00, FUN_0050bf30, FUN_00503b80, ends with jle to 0x0050700d (backward)
    lea ebx, [esi + field_4]                     # 005072c0
    push ebx                                     # 005072c3
    call FUN_0050bc00                            # 005072c4
    push ebx                                     # 005072c9
    call FUN_0050bf30                            # 005072ca
    mov ecx, dword ptr [ebp - local_4c]          # 005072cf
    inc edi                                      # 005072d2
    push esi                                     # 005072d3
    mov dword ptr [ebp - local_24], edi          # 005072d4
    mov dword ptr [ecx], eax                     # 005072d7
    add ecx, 0x4                                 # 005072d9
    mov dword ptr [ebp - local_4c], ecx          # 005072dc
    call FUN_00503b80                            # 005072df
    add esp, 0xc                                 # 005072e4
    neg eax                                      # 005072e7
    {load} sbb eax, eax                          # 005072e9
    and eax, 0x7                                 # 005072eb
    add eax, 0x7                                 # 005072ee
    {load} cmp edi, eax                          # 005072f1
    jle.d32 L_0050700d                           # 005072f3
L_005072f9:
    # block 0x005072f9: entered by jg at 0x00506ffa; fall-through of jle at 0x005072f3, 8 instruction(s), ends with ret
    lea esp, [ebp - local_78]                    # 005072f9
    {load} xor eax, eax                          # 005072fc
    pop edi                                      # 005072fe
    pop esi                                      # 005072ff
    pop ebx                                      # 00507300
    {load} mov esp, ebp                          # 00507301
    pop ebp                                      # 00507303
    ret                                          # 00507304

# --- data items (not part of the function) -------------------------
.org 0x00507305 - 0x401000
PAD_00507305:  # 11 byte(s) of nop padding
    .fill 11, 1, 0x90

