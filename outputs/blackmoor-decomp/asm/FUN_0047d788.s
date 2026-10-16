# FUN_0047d788
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047d788
# extent:       0x0047d788-0x0047df47 (1983 code bytes)
# span:         0x0047d788-0x0047df47 (code 1983, tables 0, padding 0)
# sha256:       fae8787d34e83034840e9cc7e55966eea93602bf00255b34a5e4eeea6a6ae52b
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047d788
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       27 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30, local_34 and 15 more
# fields:       [eax + n] field_1c, field_1d, field_22, field_23, field_25, field_27, field_29, field_2d, field_31, field_35, field_49, field_4d and 3 more; [ecx + n] field_1d, field_1f, field_21, field_23, field_29, field_2d, field_31, field_35, field_4d, field_51, field_55, field_minus_1; [edx + n] field_1f, field_23, field_25, field_27, field_29, field_31, field_35, field_39, field_3d, field_41, field_45, field_4d and 2 more
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0050df94, FUN_0050de00, FUN_004d39f9, FUN_004c2790, FUN_0051e7ba
# track-n:      outputs/blackmoor-decomp/src/action_family_d9_runtime.h:d9_alpha_at (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 563 instruction(s), 20 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
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
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ local_70, 0x70  # offset -0x70
.equ local_78, 0x78  # offset -0x78
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1d, 0x1d  # offset +0x1d
.equ field_1f, 0x1f  # offset +0x1f
.equ field_21, 0x21  # offset +0x21
.equ field_22, 0x22  # offset +0x22
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25
.equ field_27, 0x27  # offset +0x27
.equ field_29, 0x29  # offset +0x29
.equ field_2d, 0x2d  # offset +0x2d
.equ field_31, 0x31  # offset +0x31
.equ field_35, 0x35  # offset +0x35
.equ field_39, 0x39  # offset +0x39
.equ field_3d, 0x3d  # offset +0x3d
.equ field_41, 0x41  # offset +0x41
.equ field_45, 0x45  # offset +0x45
.equ field_49, 0x49  # offset +0x49
.equ field_4d, 0x4d  # offset +0x4d
.equ field_51, 0x51  # offset +0x51
.equ field_55, 0x55  # offset +0x55
.equ field_57, 0x57  # offset +0x57

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050de00, .text + (0x0050de00 - 0x401000)
.set FUN_0050df94, .text + (0x0050df94 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x0047d788 - 0x401000
.globl FUN_0047d788
FUN_0047d788:
    # block 0x0047d788: entry, 27 instruction(s), ends with je to 0x0047d7ff (forward)
    push ebp                                     # 0047d788
    {load} mov ebp, esp                          # 0047d789
    push -0x1                                    # 0047d78b
    push 0x528359                                # 0047d78d
    mov eax, dword ptr fs:[0x0]                  # 0047d792
    push eax                                     # 0047d798
    mov dword ptr fs:[0x0], esp                  # 0047d799
    sub esp, 0x6c                                # 0047d7a0
    push esi                                     # 0047d7a3
    push edi                                     # 0047d7a4
    mov dword ptr [ebp - local_30], ecx          # 0047d7a5
    movsx eax, word ptr [ebp + arg_8]            # 0047d7a8
    imul eax, eax, 0x8d                          # 0047d7ac
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0047d7b2
    mov dword ptr [ebp - local_20], ecx          # 0047d7b8
    mov edx, dword ptr [0x5679b0]                # 0047d7bb
    mov dword ptr [ebp - local_18], edx          # 0047d7c1
    mov dword ptr [ebp - local_4], 0x0           # 0047d7c4
    mov eax, dword ptr [0x5679b0]                # 0047d7cb
    mov dword ptr [ebp - local_1c], eax          # 0047d7d0
    mov byte ptr [ebp - local_4], 0x1            # 0047d7d3
    movsx ecx, word ptr [ebp + arg_8]            # 0047d7d7
    imul ecx, ecx, 0x8d                          # 0047d7db
    mov edx, dword ptr [ecx + 0x5bb632]          # 0047d7e1
    mov dword ptr [ebp - local_34], edx          # 0047d7e7
    cmp dword ptr [ebp - local_34], 0x0          # 0047d7ea
    je.d8 L_0047d7ff                             # 0047d7ee
    # block 0x0047d7f0: entered by fall-through of je at 0x0047d7ee, 2 instruction(s), ends with je to 0x0047dd73 (forward)
    cmp dword ptr [ebp - local_34], 0x1          # 0047d7f0
    je.d32 L_0047dd73                            # 0047d7f4
    # block 0x0047d7fa: entered by fall-through of je at 0x0047d7f4, 1 instruction(s), ends with forward jump to 0x0047df1a
    jmp.d32 L_0047df1a                           # 0047d7fa
L_0047d7ff:
    # block 0x0047d7ff: entered by je at 0x0047d7ee, 36 instruction(s), calls FUN_0051dc43, ends with jne to 0x0047d8c2 (forward)
    mov eax, dword ptr [ebp - local_30]          # 0047d7ff
    mov byte ptr [eax + field_57], 0x1           # 0047d802
    mov dword ptr [0x5bb1ca], 0x1                # 0047d806
    mov ecx, dword ptr [ebp - local_30]          # 0047d810
    mov dx, word ptr [ebp + arg_8]               # 0047d813
    mov word ptr [ecx + field_1d], dx            # 0047d817
    mov eax, dword ptr [ebp - local_30]          # 0047d81b
    mov byte ptr [eax + field_1c], 0x1           # 0047d81e
    mov ecx, dword ptr [ebp - local_20]          # 0047d822
    movzx dx, byte ptr [ecx + field_21]          # 0047d825
    mov eax, dword ptr [ebp - local_30]          # 0047d82a
    mov word ptr [eax + field_55], dx            # 0047d82d
    mov ecx, dword ptr [ebp - local_30]          # 0047d831
    mov dword ptr [ecx + field_29], 0x0          # 0047d834
    mov edx, dword ptr [ebp - local_30]          # 0047d83b
    mov dword ptr [edx + field_31], 0x0          # 0047d83e
    mov eax, dword ptr [ebp - local_30]          # 0047d845
    mov dword ptr [eax + field_2d], 0x0          # 0047d848
    mov ecx, dword ptr [ebp - local_30]          # 0047d84f
    mov dword ptr [ecx + field_35], 0x0          # 0047d852
    mov edx, dword ptr [ebp - local_30]          # 0047d859
    movsx eax, word ptr [edx + field_55]         # 0047d85c
    shl eax, 0x2                                 # 0047d860
    mov ecx, dword ptr [ebp - local_30]          # 0047d863
    movsx edx, word ptr [ecx + field_55]         # 0047d866
    imul eax, edx                                # 0047d86a
    shl eax, 0x2                                 # 0047d86d
    push eax                                     # 0047d870
    call FUN_0051dc43                            # 0047d871
    add esp, 0x4                                 # 0047d876
    mov dword ptr [ebp - local_24], eax          # 0047d879
    mov eax, dword ptr [ebp - local_30]          # 0047d87c
    mov ecx, dword ptr [ebp - local_24]          # 0047d87f
    mov dword ptr [eax + field_49], ecx          # 0047d882
    cmp dword ptr [ebp - local_24], 0x0          # 0047d885
    jne.d8 L_0047d8c2                            # 0047d889
    # block 0x0047d88b: entered by fall-through of jne at 0x0047d889, 12 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0047d8c2
    mov edx, dword ptr [0x5bb57b]                # 0047d88b
    push edx                                     # 0047d891
    push 0x54d2c0                                # 0047d892
    push 0x63888b                                # 0047d897
    call FUN_0050ca3e                            # 0047d89c
    add esp, 0xc                                 # 0047d8a1
    push 0x63888b                                # 0047d8a4
    push 0x54d2f4                                # 0047d8a9
    mov ecx, 0x583979                            # 0047d8ae
    call FUN_0042639d                            # 0047d8b3
    mov ecx, 0x5cf659                            # 0047d8b8
    call FUN_004c97b4                            # 0047d8bd
L_0047d8c2:
    # block 0x0047d8c2: entered by jne at 0x0047d889, 5 instruction(s), ends with je to 0x0047dadf (forward)
    mov eax, dword ptr [ebp - local_20]          # 0047d8c2
    {load} xor ecx, ecx                          # 0047d8c5
    mov cl, byte ptr [eax + field_22]            # 0047d8c7
    test ecx, ecx                                # 0047d8ca
    je.d32 L_0047dadf                            # 0047d8cc
    # block 0x0047d8d2: entered by fall-through of je at 0x0047d8cc, 17 instruction(s), calls FUN_0051dc43, ends with jne to 0x0047d93c (forward)
    mov edx, dword ptr [ebp - local_30]          # 0047d8d2
    movsx eax, word ptr [edx + field_55]         # 0047d8d5
    shl eax                                      # 0047d8d9
    mov ecx, dword ptr [ebp - local_30]          # 0047d8db
    movsx edx, word ptr [ecx + field_55]         # 0047d8de
    imul eax, edx                                # 0047d8e2
    shl eax                                      # 0047d8e5
    shl eax, 0x2                                 # 0047d8e7
    push eax                                     # 0047d8ea
    call FUN_0051dc43                            # 0047d8eb
    add esp, 0x4                                 # 0047d8f0
    mov dword ptr [ebp - local_28], eax          # 0047d8f3
    mov eax, dword ptr [ebp - local_30]          # 0047d8f6
    mov ecx, dword ptr [ebp - local_28]          # 0047d8f9
    mov dword ptr [eax + field_4d], ecx          # 0047d8fc
    cmp dword ptr [ebp - local_28], 0x0          # 0047d8ff
    jne.d8 L_0047d93c                            # 0047d903
    # block 0x0047d905: entered by fall-through of jne at 0x0047d903, 12 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0047d93c
    mov edx, dword ptr [0x5bb57b]                # 0047d905
    push edx                                     # 0047d90b
    push 0x54d310                                # 0047d90c
    push 0x63888b                                # 0047d911
    call FUN_0050ca3e                            # 0047d916
    add esp, 0xc                                 # 0047d91b
    push 0x63888b                                # 0047d91e
    push 0x54d344                                # 0047d923
    mov ecx, 0x583979                            # 0047d928
    call FUN_0042639d                            # 0047d92d
    mov ecx, 0x5cf659                            # 0047d932
    call FUN_004c97b4                            # 0047d937
L_0047d93c:
    # block 0x0047d93c: entered by jne at 0x0047d903, 21 instruction(s), ends with forward jump to 0x0047d97e
    mov eax, dword ptr [ebp - local_30]          # 0047d93c
    movsx ecx, word ptr [eax + field_55]         # 0047d93f
    shl ecx                                      # 0047d943
    mov edx, dword ptr [ebp - local_30]          # 0047d945
    movsx eax, word ptr [edx + field_55]         # 0047d948
    imul ecx, eax                                # 0047d94c
    shl ecx                                      # 0047d94f
    {load} xor eax, eax                          # 0047d951
    mov edx, dword ptr [ebp - local_30]          # 0047d953
    mov edi, dword ptr [edx + field_4d]          # 0047d956
    {load} mov edx, ecx                          # 0047d959
    shr ecx, 0x2                                 # 0047d95b
    rep stosd dword ptr es:[edi], eax            # 0047d95e
    {load} mov ecx, edx                          # 0047d960
    and ecx, 0x3                                 # 0047d962
    rep stosb byte ptr es:[edi], al              # 0047d965
    mov eax, dword ptr [ebp - local_30]          # 0047d967
    movsx ecx, word ptr [eax + field_55]         # 0047d96a
    neg ecx                                      # 0047d96e
    mov dword ptr [ebp - local_14], ecx          # 0047d970
    jmp.d8 L_0047d97e                            # 0047d973
L_0047d975:
    # block 0x0047d975: entered by jmp at 0x0047dad5, 3 instruction(s), falls into the block at 0x0047d97e
    mov edx, dword ptr [ebp - local_14]          # 0047d975
    add edx, 0x1                                 # 0047d978
    mov dword ptr [ebp - local_14], edx          # 0047d97b
L_0047d97e:
    # block 0x0047d97e: entered by jmp at 0x0047d973, 4 instruction(s), ends with jge to 0x0047dada (forward)
    mov eax, dword ptr [ebp - local_30]          # 0047d97e
    movsx ecx, word ptr [eax + field_55]         # 0047d981
    cmp dword ptr [ebp - local_14], ecx          # 0047d985
    jge.d32 L_0047dada                           # 0047d988
    # block 0x0047d98e: entered by fall-through of jge at 0x0047d988, 5 instruction(s), ends with forward jump to 0x0047d9a5
    mov edx, dword ptr [ebp - local_30]          # 0047d98e
    movsx eax, word ptr [edx + field_55]         # 0047d991
    neg eax                                      # 0047d995
    mov dword ptr [ebp - local_10], eax          # 0047d997
    jmp.d8 L_0047d9a5                            # 0047d99a
L_0047d99c:
    # block 0x0047d99c: entered by jmp at 0x0047dad0, 3 instruction(s), falls into the block at 0x0047d9a5
    mov ecx, dword ptr [ebp - local_10]          # 0047d99c
    add ecx, 0x1                                 # 0047d99f
    mov dword ptr [ebp - local_10], ecx          # 0047d9a2
L_0047d9a5:
    # block 0x0047d9a5: entered by jmp at 0x0047d99a, 4 instruction(s), ends with jge to 0x0047dad5 (forward)
    mov edx, dword ptr [ebp - local_30]          # 0047d9a5
    movsx eax, word ptr [edx + field_55]         # 0047d9a8
    cmp dword ptr [ebp - local_10], eax          # 0047d9ac
    jge.d32 L_0047dad5                           # 0047d9af
    # block 0x0047d9b5: entered by fall-through of jge at 0x0047d9af, 23 instruction(s), calls FUN_0050df94, ends with jne to 0x0047da2b (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0047d9b5
    imul ecx, dword ptr [ebp - local_14]         # 0047d9b8
    mov edx, dword ptr [ebp - local_10]          # 0047d9bc
    imul edx, dword ptr [ebp - local_10]         # 0047d9bf
    {load} add ecx, edx                          # 0047d9c3
    mov dword ptr [ebp - local_38], ecx          # 0047d9c5
    fild dword ptr [ebp - local_38]              # 0047d9c8
    fstp qword ptr [ebp - local_40]              # 0047d9cb
    mov eax, dword ptr [ebp - local_3c]          # 0047d9ce
    push eax                                     # 0047d9d1
    mov ecx, dword ptr [ebp - local_40]          # 0047d9d2
    push ecx                                     # 0047d9d5
    call FUN_0050df94                            # 0047d9d6
    add esp, 0x8                                 # 0047d9db
    mov edx, dword ptr [ebp - local_30]          # 0047d9de
    movsx eax, word ptr [edx + field_55]         # 0047d9e1
    mov dword ptr [ebp - local_44], eax          # 0047d9e5
    fild dword ptr [ebp - local_44]              # 0047d9e8
    fstp qword ptr [ebp - local_4c]              # 0047d9eb
    fcomp qword ptr [ebp - local_4c]             # 0047d9ee
    fnstsw ax                                    # 0047d9f1
    test ah, 0x1                                 # 0047d9f3
    jne.d8 L_0047da2b                            # 0047d9f6
    # block 0x0047d9f8: entered by fall-through of jne at 0x0047d9f6, 14 instruction(s), ends with forward jump to 0x0047dad0
    mov ecx, dword ptr [ebp - local_30]          # 0047d9f8
    movsx edx, word ptr [ecx + field_55]         # 0047d9fb
    add edx, dword ptr [ebp - local_14]          # 0047d9ff
    mov eax, dword ptr [ebp - local_30]          # 0047da02
    movsx ecx, word ptr [eax + field_55]         # 0047da05
    imul edx, ecx                                # 0047da09
    mov eax, dword ptr [ebp - local_30]          # 0047da0c
    movsx ecx, word ptr [eax + field_55]         # 0047da0f
    add ecx, dword ptr [ebp - local_10]          # 0047da13
    lea edx, [ecx + 2*edx]                       # 0047da16
    mov eax, dword ptr [ebp - local_30]          # 0047da19
    mov ecx, dword ptr [eax + field_4d]          # 0047da1c
    mov dword ptr [ecx + 4*edx], 0x0             # 0047da1f
    jmp.d32 L_0047dad0                           # 0047da26
L_0047da2b:
    # block 0x0047da2b: entered by jne at 0x0047d9f6, 53 instruction(s), calls FUN_0050de00, falls into the block at 0x0047dad0
    mov edx, dword ptr [ebp - local_14]          # 0047da2b
    imul edx, dword ptr [ebp - local_14]         # 0047da2e
    mov eax, dword ptr [ebp - local_10]          # 0047da32
    imul eax, dword ptr [ebp - local_10]         # 0047da35
    {load} add edx, eax                          # 0047da39
    mov ecx, dword ptr [ebp - local_14]          # 0047da3b
    imul ecx, dword ptr [ebp - local_14]         # 0047da3e
    mov eax, dword ptr [ebp - local_10]          # 0047da42
    imul eax, dword ptr [ebp - local_10]         # 0047da45
    {load} add ecx, eax                          # 0047da49
    imul edx, ecx                                # 0047da4b
    mov dword ptr [ebp - local_50], edx          # 0047da4e
    fild dword ptr [ebp - local_50]              # 0047da51
    fstp dword ptr [ebp - local_54]              # 0047da54
    fld dword ptr [ebp - local_54]               # 0047da57
    fchs                                         # 0047da5a
    mov ecx, dword ptr [ebp - local_30]          # 0047da5c
    movsx eax, word ptr [ecx + field_55]         # 0047da5f
    mov edx, dword ptr [ebp - local_30]          # 0047da63
    movsx ecx, word ptr [edx + field_55]         # 0047da66
    imul eax, ecx                                # 0047da6a
    mov edx, dword ptr [ebp - local_30]          # 0047da6d
    movsx ecx, word ptr [edx + field_55]         # 0047da70
    imul eax, ecx                                # 0047da74
    mov edx, dword ptr [ebp - local_30]          # 0047da77
    movsx ecx, word ptr [edx + field_55]         # 0047da7a
    imul eax, ecx                                # 0047da7e
    cdq                                          # 0047da81
    {load} sub eax, edx                          # 0047da82
    sar eax                                      # 0047da84
    mov dword ptr [ebp - local_58], eax          # 0047da86
    fild dword ptr [ebp - local_58]              # 0047da89
    fstp dword ptr [ebp - local_5c]              # 0047da8c
    fdiv dword ptr [ebp - local_5c]              # 0047da8f
    sub esp, 0x8                                 # 0047da92
    fstp qword ptr [esp]                         # 0047da95
    call FUN_0050de00                            # 0047da98
    add esp, 0x8                                 # 0047da9d
    fstp dword ptr [ebp - local_60]              # 0047daa0
    fld dword ptr [ebp - local_60]               # 0047daa3
    mov edx, dword ptr [ebp - local_30]          # 0047daa6
    movsx eax, word ptr [edx + field_55]         # 0047daa9
    add eax, dword ptr [ebp - local_14]          # 0047daad
    mov ecx, dword ptr [ebp - local_30]          # 0047dab0
    movsx edx, word ptr [ecx + field_55]         # 0047dab3
    imul eax, edx                                # 0047dab7
    mov ecx, dword ptr [ebp - local_30]          # 0047daba
    movsx edx, word ptr [ecx + field_55]         # 0047dabd
    add edx, dword ptr [ebp - local_10]          # 0047dac1
    lea eax, [edx + 2*eax]                       # 0047dac4
    mov ecx, dword ptr [ebp - local_30]          # 0047dac7
    mov edx, dword ptr [ecx + field_4d]          # 0047daca
    fstp dword ptr [edx + 4*eax]                 # 0047dacd
L_0047dad0:
    # block 0x0047dad0: entered by jmp at 0x0047da26, 1 instruction(s), ends with backward jump to 0x0047d99c
    jmp.d32 L_0047d99c                           # 0047dad0
L_0047dad5:
    # block 0x0047dad5: entered by jge at 0x0047d9af, 1 instruction(s), ends with backward jump to 0x0047d975
    jmp.d32 L_0047d975                           # 0047dad5
L_0047dada:
    # block 0x0047dada: entered by jge at 0x0047d988, 1 instruction(s), ends with forward jump to 0x0047dc38
    jmp.d32 L_0047dc38                           # 0047dada
L_0047dadf:
    # block 0x0047dadf: entered by je at 0x0047d8cc, 16 instruction(s), calls FUN_0051dc43, ends with jne to 0x0047db45 (forward)
    mov eax, dword ptr [ebp - local_30]          # 0047dadf
    movsx ecx, word ptr [eax + field_55]         # 0047dae2
    shl ecx                                      # 0047dae6
    mov edx, dword ptr [ebp - local_30]          # 0047dae8
    movsx eax, word ptr [edx + field_55]         # 0047daeb
    imul ecx, eax                                # 0047daef
    shl ecx                                      # 0047daf2
    push ecx                                     # 0047daf4
    call FUN_0051dc43                            # 0047daf5
    add esp, 0x4                                 # 0047dafa
    mov dword ptr [ebp - local_2c], eax          # 0047dafd
    mov ecx, dword ptr [ebp - local_30]          # 0047db00
    mov edx, dword ptr [ebp - local_2c]          # 0047db03
    mov dword ptr [ecx + field_51], edx          # 0047db06
    cmp dword ptr [ebp - local_2c], 0x0          # 0047db09
    jne.d8 L_0047db45                            # 0047db0d
    # block 0x0047db0f: entered by fall-through of jne at 0x0047db0d, 12 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0047db45
    mov eax, dword ptr [0x5bb57b]                # 0047db0f
    push eax                                     # 0047db14
    push 0x54d360                                # 0047db15
    push 0x63888b                                # 0047db1a
    call FUN_0050ca3e                            # 0047db1f
    add esp, 0xc                                 # 0047db24
    push 0x63888b                                # 0047db27
    push 0x54d390                                # 0047db2c
    mov ecx, 0x583979                            # 0047db31
    call FUN_0042639d                            # 0047db36
    mov ecx, 0x5cf659                            # 0047db3b
    call FUN_004c97b4                            # 0047db40
L_0047db45:
    # block 0x0047db45: entered by jne at 0x0047db0d, 5 instruction(s), ends with forward jump to 0x0047db5c
    mov ecx, dword ptr [ebp - local_30]          # 0047db45
    movsx edx, word ptr [ecx + field_55]         # 0047db48
    neg edx                                      # 0047db4c
    mov dword ptr [ebp - local_14], edx          # 0047db4e
    jmp.d8 L_0047db5c                            # 0047db51
L_0047db53:
    # block 0x0047db53: entered by jmp at 0x0047dc33, 3 instruction(s), falls into the block at 0x0047db5c
    mov eax, dword ptr [ebp - local_14]          # 0047db53
    add eax, 0x1                                 # 0047db56
    mov dword ptr [ebp - local_14], eax          # 0047db59
L_0047db5c:
    # block 0x0047db5c: entered by jmp at 0x0047db51, 4 instruction(s), ends with jge to 0x0047dc38 (forward)
    mov ecx, dword ptr [ebp - local_30]          # 0047db5c
    movsx edx, word ptr [ecx + field_55]         # 0047db5f
    cmp dword ptr [ebp - local_14], edx          # 0047db63
    jge.d32 L_0047dc38                           # 0047db66
    # block 0x0047db6c: entered by fall-through of jge at 0x0047db66, 5 instruction(s), ends with forward jump to 0x0047db83
    mov eax, dword ptr [ebp - local_30]          # 0047db6c
    movsx ecx, word ptr [eax + field_55]         # 0047db6f
    neg ecx                                      # 0047db73
    mov dword ptr [ebp - local_10], ecx          # 0047db75
    jmp.d8 L_0047db83                            # 0047db78
L_0047db7a:
    # block 0x0047db7a: entered by jmp at 0x0047dc2e, 3 instruction(s), falls into the block at 0x0047db83
    mov edx, dword ptr [ebp - local_10]          # 0047db7a
    add edx, 0x1                                 # 0047db7d
    mov dword ptr [ebp - local_10], edx          # 0047db80
L_0047db83:
    # block 0x0047db83: entered by jmp at 0x0047db78, 4 instruction(s), ends with jge to 0x0047dc33 (forward)
    mov eax, dword ptr [ebp - local_30]          # 0047db83
    movsx ecx, word ptr [eax + field_55]         # 0047db86
    cmp dword ptr [ebp - local_10], ecx          # 0047db8a
    jge.d32 L_0047dc33                           # 0047db8d
    # block 0x0047db93: entered by fall-through of jge at 0x0047db8d, 23 instruction(s), calls FUN_0050df94, ends with je to 0x0047dc03 (forward)
    mov edx, dword ptr [ebp - local_14]          # 0047db93
    imul edx, dword ptr [ebp - local_14]         # 0047db96
    mov eax, dword ptr [ebp - local_10]          # 0047db9a
    imul eax, dword ptr [ebp - local_10]         # 0047db9d
    {load} add edx, eax                          # 0047dba1
    mov dword ptr [ebp - local_64], edx          # 0047dba3
    fild dword ptr [ebp - local_64]              # 0047dba6
    fstp qword ptr [ebp - local_6c]              # 0047dba9
    mov ecx, dword ptr [ebp - local_68]          # 0047dbac
    push ecx                                     # 0047dbaf
    mov edx, dword ptr [ebp - local_6c]          # 0047dbb0
    push edx                                     # 0047dbb3
    call FUN_0050df94                            # 0047dbb4
    add esp, 0x8                                 # 0047dbb9
    mov eax, dword ptr [ebp - local_30]          # 0047dbbc
    movsx ecx, word ptr [eax + field_55]         # 0047dbbf
    mov dword ptr [ebp - local_70], ecx          # 0047dbc3
    fild dword ptr [ebp - local_70]              # 0047dbc6
    fstp qword ptr [ebp - local_78]              # 0047dbc9
    fcomp qword ptr [ebp - local_78]             # 0047dbcc
    fnstsw ax                                    # 0047dbcf
    test ah, 0x1                                 # 0047dbd1
    je.d8 L_0047dc03                             # 0047dbd4
    # block 0x0047dbd6: entered by fall-through of je at 0x0047dbd4, 14 instruction(s), ends with forward jump to 0x0047dc2e
    mov edx, dword ptr [ebp - local_30]          # 0047dbd6
    movsx eax, word ptr [edx + field_55]         # 0047dbd9
    add eax, dword ptr [ebp - local_14]          # 0047dbdd
    mov ecx, dword ptr [ebp - local_30]          # 0047dbe0
    movsx edx, word ptr [ecx + field_55]         # 0047dbe3
    imul eax, edx                                # 0047dbe7
    mov ecx, dword ptr [ebp - local_30]          # 0047dbea
    movsx edx, word ptr [ecx + field_55]         # 0047dbed
    add edx, dword ptr [ebp - local_10]          # 0047dbf1
    lea eax, [edx + 2*eax]                       # 0047dbf4
    mov ecx, dword ptr [ebp - local_30]          # 0047dbf7
    mov edx, dword ptr [ecx + field_51]          # 0047dbfa
    mov byte ptr [edx + eax], 0x1                # 0047dbfd
    jmp.d8 L_0047dc2e                            # 0047dc01
L_0047dc03:
    # block 0x0047dc03: entered by je at 0x0047dbd4, 13 instruction(s), falls into the block at 0x0047dc2e
    mov eax, dword ptr [ebp - local_30]          # 0047dc03
    movsx ecx, word ptr [eax + field_55]         # 0047dc06
    add ecx, dword ptr [ebp - local_14]          # 0047dc0a
    mov edx, dword ptr [ebp - local_30]          # 0047dc0d
    movsx eax, word ptr [edx + field_55]         # 0047dc10
    imul ecx, eax                                # 0047dc14
    mov edx, dword ptr [ebp - local_30]          # 0047dc17
    movsx eax, word ptr [edx + field_55]         # 0047dc1a
    add eax, dword ptr [ebp - local_10]          # 0047dc1e
    lea ecx, [eax + 2*ecx]                       # 0047dc21
    mov edx, dword ptr [ebp - local_30]          # 0047dc24
    mov eax, dword ptr [edx + field_51]          # 0047dc27
    mov byte ptr [eax + ecx], 0x0                # 0047dc2a
L_0047dc2e:
    # block 0x0047dc2e: entered by jmp at 0x0047dc01, 1 instruction(s), ends with backward jump to 0x0047db7a
    jmp.d32 L_0047db7a                           # 0047dc2e
L_0047dc33:
    # block 0x0047dc33: entered by jge at 0x0047db8d, 1 instruction(s), ends with backward jump to 0x0047db53
    jmp.d32 L_0047db53                           # 0047dc33
L_0047dc38:
    # block 0x0047dc38: entered by jmp at 0x0047dada; jge at 0x0047db66, 59 instruction(s), calls FUN_004d39f9, ends with jne to 0x0047dd41 (forward)
    call FUN_004d39f9                            # 0047dc38
    mov ecx, dword ptr [ebp - local_30]          # 0047dc3d
    mov word ptr [ecx + field_23], ax            # 0047dc40
    mov edx, dword ptr [ebp - local_30]          # 0047dc44
    movsx eax, word ptr [edx + field_23]         # 0047dc47
    imul eax, eax, 0x4a                          # 0047dc4b
    mov dword ptr [eax + 0x5d1591], 0xa          # 0047dc4e
    mov ecx, dword ptr [ebp - local_30]          # 0047dc58
    movsx edx, word ptr [ecx + field_23]         # 0047dc5b
    imul edx, edx, 0x4a                          # 0047dc5f
    mov dword ptr [edx + 0x5d1595], 0x47df57     # 0047dc62
    mov eax, dword ptr [ebp - local_30]          # 0047dc6c
    movsx ecx, word ptr [eax + field_23]         # 0047dc6f
    imul ecx, ecx, 0x4a                          # 0047dc73
    mov edx, dword ptr [ebp - local_30]          # 0047dc76
    mov eax, dword ptr [edx + field_1f]          # 0047dc79
    mov dword ptr [ecx + 0x5d1599], eax          # 0047dc7c
    mov ecx, dword ptr [ebp - local_30]          # 0047dc82
    movsx edx, word ptr [ecx + field_23]         # 0047dc85
    imul edx, edx, 0x4a                          # 0047dc89
    mov dword ptr [edx + 0x5d159d], 0x0          # 0047dc8c
    mov eax, dword ptr [ebp - local_30]          # 0047dc96
    movsx ecx, word ptr [eax + field_23]         # 0047dc99
    imul ecx, ecx, 0x4a                          # 0047dc9d
    mov dword ptr [ecx + 0x5d15a1], 0x0          # 0047dca0
    mov edx, dword ptr [ebp - local_30]          # 0047dcaa
    movsx eax, word ptr [edx + field_23]         # 0047dcad
    imul eax, eax, 0x4a                          # 0047dcb1
    mov dword ptr [eax + 0x5d15a5], 0x1          # 0047dcb4
    mov ecx, dword ptr [ebp - local_30]          # 0047dcbe
    movsx edx, word ptr [ecx + field_23]         # 0047dcc1
    imul edx, edx, 0x4a                          # 0047dcc5
    mov dword ptr [edx + 0x5d15a9], 0x1          # 0047dcc8
    mov eax, dword ptr [ebp - local_30]          # 0047dcd2
    movsx ecx, word ptr [eax + field_23]         # 0047dcd5
    imul ecx, ecx, 0x4a                          # 0047dcd9
    mov word ptr [ecx + 0x5d15ad], 0x0           # 0047dcdc
    mov edi, 0x54d3ac                            # 0047dce5
    mov edx, dword ptr [ebp - local_30]          # 0047dcea
    movsx eax, word ptr [edx + field_23]         # 0047dced
    imul eax, eax, 0x4a                          # 0047dcf1
    add eax, 0x5d15b3                            # 0047dcf4
    {load} mov edx, eax                          # 0047dcf9
    or ecx, -0x1                                 # 0047dcfb
    {load} xor eax, eax                          # 0047dcfe
    repne scasb al, byte ptr es:[edi]            # 0047dd00
    not ecx                                      # 0047dd02
    {load} sub edi, ecx                          # 0047dd04
    {load} mov esi, edi                          # 0047dd06
    {load} mov eax, ecx                          # 0047dd08
    {load} mov edi, edx                          # 0047dd0a
    shr ecx, 0x2                                 # 0047dd0c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0047dd0f
    {load} mov ecx, eax                          # 0047dd11
    and ecx, 0x3                                 # 0047dd13
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0047dd16
    mov ecx, dword ptr [ebp - local_30]          # 0047dd18
    cmp dword ptr [ecx + field_1f], 0x0          # 0047dd1b
    jne.d8 L_0047dd41                            # 0047dd1f
    # block 0x0047dd21: entered by fall-through of jne at 0x0047dd1f, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x0047dd41
    push 0x54d3c8                                # 0047dd21
    push 0x6                                     # 0047dd26
    mov edx, dword ptr [ebp - local_20]          # 0047dd28
    push edx                                     # 0047dd2b
    push 0x54d3e4                                # 0047dd2c
    mov ecx, 0x5cf659                            # 0047dd31
    call FUN_004c2790                            # 0047dd36
    mov ecx, dword ptr [ebp - local_30]          # 0047dd3b
    mov dword ptr [ecx + field_1f], eax          # 0047dd3e
L_0047dd41:
    # block 0x0047dd41: entered by jne at 0x0047dd1f, 11 instruction(s), ends with forward jump to 0x0047df1a
    mov edx, dword ptr [ebp - local_30]          # 0047dd41
    movsx eax, word ptr [edx + field_23]         # 0047dd44
    imul eax, eax, 0x4a                          # 0047dd48
    mov ecx, dword ptr [ebp - local_30]          # 0047dd4b
    mov edx, dword ptr [ecx + field_1f]          # 0047dd4e
    mov dword ptr [eax + 0x5d1599], edx          # 0047dd51
    mov eax, dword ptr [ebp - local_30]          # 0047dd57
    movsx ecx, word ptr [eax + field_1d]         # 0047dd5a
    imul ecx, ecx, 0x8d                          # 0047dd5e
    mov dword ptr [ecx + 0x5bb632], 0x1          # 0047dd64
    jmp.d32 L_0047df1a                           # 0047dd6e
L_0047dd73:
    # block 0x0047dd73: entered by je at 0x0047d7f4, 23 instruction(s), ends with jle to 0x0047ddea (forward)
    mov edx, dword ptr [ebp - local_30]          # 0047dd73
    mov eax, dword ptr [ebp - local_30]          # 0047dd76
    mov ecx, dword ptr [eax + field_29]          # 0047dd79
    mov dword ptr [edx + field_39], ecx          # 0047dd7c
    mov edx, dword ptr [ebp - local_30]          # 0047dd7f
    mov eax, dword ptr [ebp - local_30]          # 0047dd82
    mov ecx, dword ptr [eax + field_31]          # 0047dd85
    mov dword ptr [edx + field_41], ecx          # 0047dd88
    mov edx, dword ptr [ebp - local_30]          # 0047dd8b
    mov eax, dword ptr [ebp - local_30]          # 0047dd8e
    mov ecx, dword ptr [eax + field_2d]          # 0047dd91
    mov dword ptr [edx + field_3d], ecx          # 0047dd94
    mov edx, dword ptr [ebp - local_30]          # 0047dd97
    mov eax, dword ptr [ebp - local_30]          # 0047dd9a
    mov ecx, dword ptr [eax + field_35]          # 0047dd9d
    mov dword ptr [edx + field_45], ecx          # 0047dda0
    mov edx, dword ptr [ebp - local_30]          # 0047dda3
    movsx eax, word ptr [edx + field_27]         # 0047dda6
    mov ecx, dword ptr [0x583192]                # 0047ddaa
    sub ecx, dword ptr [0x58318a]                # 0047ddb0
    add ecx, 0x5                                 # 0047ddb6
    {load} cmp eax, ecx                          # 0047ddb9
    jle.d8 L_0047ddea                            # 0047ddbb
    # block 0x0047ddbd: entered by fall-through of jle at 0x0047ddbb, 9 instruction(s), ends with forward jump to 0x0047df1a
    mov edx, dword ptr [ebp - local_30]          # 0047ddbd
    mov dword ptr [edx + field_29], 0x0          # 0047ddc0
    mov eax, dword ptr [ebp - local_30]          # 0047ddc7
    mov dword ptr [eax + field_31], 0x0          # 0047ddca
    mov ecx, dword ptr [ebp - local_30]          # 0047ddd1
    mov dword ptr [ecx + field_2d], 0x0          # 0047ddd4
    mov edx, dword ptr [ebp - local_30]          # 0047dddb
    mov dword ptr [edx + field_35], 0x0          # 0047ddde
    jmp.d32 L_0047df1a                           # 0047dde5
L_0047ddea:
    # block 0x0047ddea: entered by jle at 0x0047ddbb, 7 instruction(s), ends with jge to 0x0047de0a (forward)
    mov eax, dword ptr [ebp - local_30]          # 0047ddea
    movsx ecx, word ptr [eax + field_25]         # 0047dded
    mov edx, dword ptr [ebp - local_30]          # 0047ddf1
    movsx eax, word ptr [edx + field_55]         # 0047ddf4
    {load} sub ecx, eax                          # 0047ddf8
    test ecx, ecx                                # 0047ddfa
    jge.d8 L_0047de0a                            # 0047ddfc
    # block 0x0047ddfe: entered by fall-through of jge at 0x0047ddfc, 3 instruction(s), ends with forward jump to 0x0047de20
    mov ecx, dword ptr [ebp - local_30]          # 0047ddfe
    mov dword ptr [ecx + field_29], 0x0          # 0047de01
    jmp.d8 L_0047de20                            # 0047de08
L_0047de0a:
    # block 0x0047de0a: entered by jge at 0x0047ddfc, 7 instruction(s), falls into the block at 0x0047de20
    mov edx, dword ptr [ebp - local_30]          # 0047de0a
    movsx eax, word ptr [edx + field_25]         # 0047de0d
    mov ecx, dword ptr [ebp - local_30]          # 0047de11
    movsx edx, word ptr [ecx + field_55]         # 0047de14
    {load} sub eax, edx                          # 0047de18
    mov ecx, dword ptr [ebp - local_30]          # 0047de1a
    mov dword ptr [ecx + field_29], eax          # 0047de1d
L_0047de20:
    # block 0x0047de20: entered by jmp at 0x0047de08, 7 instruction(s), ends with jle to 0x0047de48 (forward)
    mov edx, dword ptr [ebp - local_30]          # 0047de20
    movsx eax, word ptr [edx + field_25]         # 0047de23
    mov ecx, dword ptr [ebp - local_30]          # 0047de27
    movsx edx, word ptr [ecx + field_55]         # 0047de2a
    lea eax, [eax + edx - field_minus_1]         # 0047de2e
    cmp eax, dword ptr [0x5831ae]                # 0047de32
    jle.d8 L_0047de48                            # 0047de38
    # block 0x0047de3a: entered by fall-through of jle at 0x0047de38, 4 instruction(s), ends with forward jump to 0x0047de82
    mov ecx, dword ptr [ebp - local_30]          # 0047de3a
    mov edx, dword ptr [0x5831ae]                # 0047de3d
    mov dword ptr [ecx + field_31], edx          # 0047de43
    jmp.d8 L_0047de82                            # 0047de46
L_0047de48:
    # block 0x0047de48: entered by jle at 0x0047de38, 7 instruction(s), ends with jge to 0x0047de6a (forward)
    mov eax, dword ptr [ebp - local_30]          # 0047de48
    movsx ecx, word ptr [eax + field_25]         # 0047de4b
    mov edx, dword ptr [ebp - local_30]          # 0047de4f
    movsx eax, word ptr [edx + field_55]         # 0047de52
    lea ecx, [ecx + eax - field_minus_1]         # 0047de56
    test ecx, ecx                                # 0047de5a
    jge.d8 L_0047de6a                            # 0047de5c
    # block 0x0047de5e: entered by fall-through of jge at 0x0047de5c, 3 instruction(s), ends with forward jump to 0x0047de82
    mov edx, dword ptr [ebp - local_30]          # 0047de5e
    mov dword ptr [edx + field_31], 0x0          # 0047de61
    jmp.d8 L_0047de82                            # 0047de68
L_0047de6a:
    # block 0x0047de6a: entered by jge at 0x0047de5c, 7 instruction(s), falls into the block at 0x0047de82
    mov eax, dword ptr [ebp - local_30]          # 0047de6a
    movsx ecx, word ptr [eax + field_25]         # 0047de6d
    mov edx, dword ptr [ebp - local_30]          # 0047de71
    movsx eax, word ptr [edx + field_55]         # 0047de74
    lea ecx, [ecx + eax - field_minus_1]         # 0047de78
    mov edx, dword ptr [ebp - local_30]          # 0047de7c
    mov dword ptr [edx + field_31], ecx          # 0047de7f
L_0047de82:
    # block 0x0047de82: entered by jmp at 0x0047de46; jmp at 0x0047de68, 7 instruction(s), ends with jge to 0x0047dea2 (forward)
    mov eax, dword ptr [ebp - local_30]          # 0047de82
    movsx ecx, word ptr [eax + field_27]         # 0047de85
    mov edx, dword ptr [ebp - local_30]          # 0047de89
    movsx eax, word ptr [edx + field_55]         # 0047de8c
    {load} sub ecx, eax                          # 0047de90
    test ecx, ecx                                # 0047de92
    jge.d8 L_0047dea2                            # 0047de94
    # block 0x0047de96: entered by fall-through of jge at 0x0047de94, 3 instruction(s), ends with forward jump to 0x0047deb8
    mov ecx, dword ptr [ebp - local_30]          # 0047de96
    mov dword ptr [ecx + field_2d], 0x0          # 0047de99
    jmp.d8 L_0047deb8                            # 0047dea0
L_0047dea2:
    # block 0x0047dea2: entered by jge at 0x0047de94, 7 instruction(s), falls into the block at 0x0047deb8
    mov edx, dword ptr [ebp - local_30]          # 0047dea2
    movsx eax, word ptr [edx + field_27]         # 0047dea5
    mov ecx, dword ptr [ebp - local_30]          # 0047dea9
    movsx edx, word ptr [ecx + field_55]         # 0047deac
    {load} sub eax, edx                          # 0047deb0
    mov ecx, dword ptr [ebp - local_30]          # 0047deb2
    mov dword ptr [ecx + field_2d], eax          # 0047deb5
L_0047deb8:
    # block 0x0047deb8: entered by jmp at 0x0047dea0, 7 instruction(s), ends with jle to 0x0047dee0 (forward)
    mov edx, dword ptr [ebp - local_30]          # 0047deb8
    movsx eax, word ptr [edx + field_27]         # 0047debb
    mov ecx, dword ptr [ebp - local_30]          # 0047debf
    movsx edx, word ptr [ecx + field_55]         # 0047dec2
    lea eax, [eax + edx - field_minus_1]         # 0047dec6
    cmp eax, dword ptr [0x5831b2]                # 0047deca
    jle.d8 L_0047dee0                            # 0047ded0
    # block 0x0047ded2: entered by fall-through of jle at 0x0047ded0, 4 instruction(s), ends with forward jump to 0x0047df1a
    mov ecx, dword ptr [ebp - local_30]          # 0047ded2
    mov edx, dword ptr [0x5831b2]                # 0047ded5
    mov dword ptr [ecx + field_35], edx          # 0047dedb
    jmp.d8 L_0047df1a                            # 0047dede
L_0047dee0:
    # block 0x0047dee0: entered by jle at 0x0047ded0, 7 instruction(s), ends with jge to 0x0047df02 (forward)
    mov eax, dword ptr [ebp - local_30]          # 0047dee0
    movsx ecx, word ptr [eax + field_27]         # 0047dee3
    mov edx, dword ptr [ebp - local_30]          # 0047dee7
    movsx eax, word ptr [edx + field_55]         # 0047deea
    lea ecx, [ecx + eax - field_minus_1]         # 0047deee
    test ecx, ecx                                # 0047def2
    jge.d8 L_0047df02                            # 0047def4
    # block 0x0047def6: entered by fall-through of jge at 0x0047def4, 3 instruction(s), ends with forward jump to 0x0047df1a
    mov edx, dword ptr [ebp - local_30]          # 0047def6
    mov dword ptr [edx + field_35], 0x0          # 0047def9
    jmp.d8 L_0047df1a                            # 0047df00
L_0047df02:
    # block 0x0047df02: entered by jge at 0x0047def4, 7 instruction(s), falls into the block at 0x0047df1a
    mov eax, dword ptr [ebp - local_30]          # 0047df02
    movsx ecx, word ptr [eax + field_27]         # 0047df05
    mov edx, dword ptr [ebp - local_30]          # 0047df09
    movsx eax, word ptr [edx + field_55]         # 0047df0c
    lea ecx, [ecx + eax - field_minus_1]         # 0047df10
    mov edx, dword ptr [ebp - local_30]          # 0047df14
    mov dword ptr [edx + field_35], ecx          # 0047df17
L_0047df1a:
    # block 0x0047df1a: entered by jmp at 0x0047d7fa; jmp at 0x0047dd6e; jmp at 0x0047dde5; jmp at 0x0047dede; more, 13 instruction(s), calls FUN_0051e7ba, ends with ret 0x4
    mov byte ptr [ebp - local_4], 0x0            # 0047df1a
    lea ecx, [ebp - local_1c]                    # 0047df1e
    call FUN_0051e7ba                            # 0047df21
    mov dword ptr [ebp - local_4], 0xffffffff    # 0047df26
    lea ecx, [ebp - local_18]                    # 0047df2d
    call FUN_0051e7ba                            # 0047df30
    mov ecx, dword ptr [ebp - local_c]           # 0047df35
    mov dword ptr fs:[0x0], ecx                  # 0047df38
    pop edi                                      # 0047df3f
    pop esi                                      # 0047df40
    {load} mov esp, ebp                          # 0047df41
    pop ebp                                      # 0047df43
    ret 0x4                                      # 0047df44

