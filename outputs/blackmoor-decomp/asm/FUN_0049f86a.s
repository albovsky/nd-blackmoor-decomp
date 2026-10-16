# FUN_0049f86a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049f86a
# extent:       0x0049f86a-0x004a0365 (2811 code bytes)
# span:         0x0049f86a-0x004a0365 (code 2811, tables 0, padding 0)
# sha256:       13aec26b9e85ec219f3c2762ad42312a9ce955a9ae627880ad3b541dce8824c1
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0049f86a
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       32 ebp-relative slot(s): local_28, local_2c, local_30, local_34, local_38, local_3c, local_40, local_44, local_48, local_4c, local_50, local_54 and 20 more
# fields:       [eax + n] field_4, field_1c, field_20, field_24, field_140, field_e0c, field_e38, field_e40, field_e44, field_e48, field_minus_4; [ecx + n] field_4, field_1c, field_2c, field_e1c, field_e20, field_e2c, field_e38, field_e40, field_e44; [edx + n] field_4, field_1c, field_2c, field_118, field_186, field_e38, field_minus_4
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_0050ce04, FUN_0050cd50
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 683 instruction(s), 47 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
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
.equ local_70, 0x70  # offset -0x70
.equ local_74, 0x74  # offset -0x74
.equ local_78, 0x78  # offset -0x78
.equ local_7c, 0x7c  # offset -0x7c
.equ local_80, 0x80  # offset -0x80
.equ local_94, 0x94  # offset -0x94
.equ local_98, 0x98  # offset -0x98
.equ local_9c, 0x9c  # offset -0x9c
.equ local_a0, 0xa0  # offset -0xa0
.equ local_a4, 0xa4  # offset -0xa4
.equ local_a8, 0xa8  # offset -0xa8
.equ local_ac, 0xac  # offset -0xac
.equ local_b0, 0xb0  # offset -0xb0
.equ local_b4, 0xb4  # offset -0xb4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_2c, 0x2c  # offset +0x2c
.equ field_118, 0x118  # offset +0x118
.equ field_140, 0x140  # offset +0x140
.equ field_186, 0x186  # offset +0x186
.equ field_e0c, 0xe0c  # offset +0xe0c
.equ field_e1c, 0xe1c  # offset +0xe1c
.equ field_e20, 0xe20  # offset +0xe20
.equ field_e2c, 0xe2c  # offset +0xe2c
.equ field_e38, 0xe38  # offset +0xe38
.equ field_e40, 0xe40  # offset +0xe40
.equ field_e44, 0xe44  # offset +0xe44
.equ field_e48, 0xe48  # offset +0xe48

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0049f86a - 0x401000
.globl FUN_0049f86a
FUN_0049f86a:
    # block 0x0049f86a: entry, 11 instruction(s), ends with forward jump to 0x0049f8ab
    push ebp                                     # 0049f86a
    {load} mov ebp, esp                          # 0049f86b
    sub esp, 0xb4                                # 0049f86d
    mov dword ptr [ebp - local_a4], ecx          # 0049f873
    mov eax, dword ptr [ebp - local_a4]          # 0049f879
    mov ecx, dword ptr [0x6329d5]                # 0049f87f
    imul ecx, dword ptr [eax + field_e0c]        # 0049f885
    mov dword ptr [ebp - local_3c], ecx          # 0049f88c
    mov dword ptr [ebp - local_a0], 0x0          # 0049f88f
    mov dword ptr [ebp - local_58], 0x0          # 0049f899
    jmp.d8 L_0049f8ab                            # 0049f8a0
L_0049f8a2:
    # block 0x0049f8a2: entered by jmp at 0x0049f8db; jmp at 0x0049f96a, 3 instruction(s), falls into the block at 0x0049f8ab
    mov edx, dword ptr [ebp - local_58]          # 0049f8a2
    add edx, 0x1                                 # 0049f8a5
    mov dword ptr [ebp - local_58], edx          # 0049f8a8
L_0049f8ab:
    # block 0x0049f8ab: entered by jmp at 0x0049f8a0, 2 instruction(s), ends with jge to 0x0049f96f (forward)
    cmp dword ptr [ebp - local_58], 0xa          # 0049f8ab
    jge.d32 L_0049f96f                           # 0049f8af
    # block 0x0049f8b5: entered by fall-through of jge at 0x0049f8af, 9 instruction(s), ends with jne to 0x0049f8dd (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0049f8b5
    imul eax, eax, 0x15e                         # 0049f8b8
    mov ecx, dword ptr [ebp - local_a4]          # 0049f8be
    lea edx, [ecx + eax + field_2c]              # 0049f8c4
    mov eax, dword ptr [ebp - local_58]          # 0049f8c8
    mov ecx, dword ptr [edx + 4*eax + field_118] # 0049f8cb
    mov dword ptr [ebp - local_54], ecx          # 0049f8d2
    cmp dword ptr [ebp - local_54], -0x1         # 0049f8d5
    jne.d8 L_0049f8dd                            # 0049f8d9
    # block 0x0049f8db: entered by fall-through of jne at 0x0049f8d9, 1 instruction(s), ends with backward jump to 0x0049f8a2
    jmp.d8 L_0049f8a2                            # 0049f8db
L_0049f8dd:
    # block 0x0049f8dd: entered by jne at 0x0049f8d9, 15 instruction(s), ends with jne to 0x0049f95b (forward)
    mov edx, dword ptr [ebp - local_a0]          # 0049f8dd
    mov eax, dword ptr [ebp - local_54]          # 0049f8e3
    mov dword ptr [ebp + 4*edx - local_28], eax  # 0049f8e6
    mov ecx, dword ptr [ebp + arg_8]             # 0049f8ea
    imul ecx, ecx, 0x15e                         # 0049f8ed
    mov edx, dword ptr [ebp - local_a4]          # 0049f8f3
    lea eax, [edx + ecx + field_2c]              # 0049f8f9
    mov ecx, dword ptr [ebp - local_a0]          # 0049f8fd
    mov edx, dword ptr [ebp - local_58]          # 0049f903
    mov ax, word ptr [eax + 2*edx + field_140]   # 0049f906
    mov word ptr [ebp + 2*ecx - local_94], ax    # 0049f90e
    mov ecx, dword ptr [ebp - local_a0]          # 0049f916
    movsx edx, word ptr [ebp + 2*ecx - local_94] # 0049f91c
    cmp edx, -0x1                                # 0049f924
    jne.d8 L_0049f95b                            # 0049f927
    # block 0x0049f929: entered by fall-through of jne at 0x0049f927, 14 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049f95b
    mov eax, dword ptr [ebp + arg_8]             # 0049f929
    push eax                                     # 0049f92c
    mov ecx, dword ptr [ebp - local_54]          # 0049f92d
    push ecx                                     # 0049f930
    push 0x54ff54                                # 0049f931
    push 0x63888b                                # 0049f936
    call FUN_0050ca3e                            # 0049f93b
    add esp, 0x10                                # 0049f940
    push 0x0                                     # 0049f943
    push 0x0                                     # 0049f945
    push 0x63888b                                # 0049f947
    call FUN_0052139c                            # 0049f94c
    mov ecx, 0x5cf659                            # 0049f951
    call FUN_004c97b4                            # 0049f956
L_0049f95b:
    # block 0x0049f95b: entered by jne at 0x0049f927, 4 instruction(s), ends with backward jump to 0x0049f8a2
    mov edx, dword ptr [ebp - local_a0]          # 0049f95b
    add edx, 0x1                                 # 0049f961
    mov dword ptr [ebp - local_a0], edx          # 0049f964
    jmp.d32 L_0049f8a2                           # 0049f96a
L_0049f96f:
    # block 0x0049f96f: entered by jge at 0x0049f8af, 2 instruction(s), ends with jne to 0x0049f9a6 (forward)
    cmp dword ptr [ebp - local_a0], 0x0          # 0049f96f
    jne.d8 L_0049f9a6                            # 0049f976
    # block 0x0049f978: entered by fall-through of jne at 0x0049f976, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049f9a6
    mov eax, dword ptr [ebp + arg_8]             # 0049f978
    push eax                                     # 0049f97b
    push 0x54ffb8                                # 0049f97c
    push 0x63888b                                # 0049f981
    call FUN_0050ca3e                            # 0049f986
    add esp, 0xc                                 # 0049f98b
    push 0x0                                     # 0049f98e
    push 0x0                                     # 0049f990
    push 0x63888b                                # 0049f992
    call FUN_0052139c                            # 0049f997
    mov ecx, 0x5cf659                            # 0049f99c
    call FUN_004c97b4                            # 0049f9a1
L_0049f9a6:
    # block 0x0049f9a6: entered by jne at 0x0049f976, 13 instruction(s), calls FUN_0050ce04, falls into the block at 0x0049f9f0
    mov ecx, dword ptr [ebp + arg_8]             # 0049f9a6
    imul ecx, ecx, 0x15e                         # 0049f9a9
    mov edx, dword ptr [ebp - local_a4]          # 0049f9af
    movsx eax, word ptr [edx + ecx + field_186]  # 0049f9b5
    mov dword ptr [ebp - local_a8], eax          # 0049f9bd
    fild dword ptr [ebp - local_a8]              # 0049f9c3
    fstp dword ptr [ebp - local_ac]              # 0049f9c9
    mov ecx, dword ptr [ebp - local_a4]          # 0049f9cf
    fld dword ptr [ebp - local_ac]               # 0049f9d5
    fmul dword ptr [ecx + field_e2c]             # 0049f9db
    call FUN_0050ce04                            # 0049f9e1
    mov dword ptr [ebp - local_74], eax          # 0049f9e6
    mov dword ptr [ebp - local_34], 0x0          # 0049f9e9
L_0049f9f0:
    # block 0x0049f9f0: entered by jmp at 0x004a035a, 3 instruction(s), ends with jge to 0x004a035f (forward)
    mov edx, dword ptr [ebp - local_34]          # 0049f9f0
    cmp edx, dword ptr [ebp - local_74]          # 0049f9f3
    jge.d32 L_004a035f                           # 0049f9f6
    # block 0x0049f9fc: entered by fall-through of jge at 0x0049f9f6, 3 instruction(s), calls FUN_0050cd50, ends with jns to 0x0049fa0d (forward)
    call FUN_0050cd50                            # 0049f9fc
    and eax, 0x80000001                          # 0049fa01
    jns.d8 L_0049fa0d                            # 0049fa06
    # block 0x0049fa08: entered by fall-through of jns at 0x0049fa06, 3 instruction(s), falls into the block at 0x0049fa0d
    dec eax                                      # 0049fa08
    or eax, -0x2                                 # 0049fa09
    inc eax                                      # 0049fa0c
L_0049fa0d:
    # block 0x0049fa0d: entered by jns at 0x0049fa06, 7 instruction(s), falls into the block at 0x0049fa34
    mov dword ptr [ebp - local_30], eax          # 0049fa0d
    mov dword ptr [ebp - local_5c], 0x0          # 0049fa10
    mov dword ptr [ebp - local_64], 0x0          # 0049fa17
    mov eax, dword ptr [ebp - local_a4]          # 0049fa1e
    mov ecx, dword ptr [eax + field_24]          # 0049fa24
    mov dword ptr [ebp - local_98], ecx          # 0049fa27
    mov dword ptr [ebp - local_60], 0x0          # 0049fa2d
L_0049fa34:
    # block 0x0049fa34: entered by jmp at 0x0049fab7; jmp at 0x0049faea; jmp at 0x0049ffb1, 2 instruction(s), ends with jne to 0x0049ffb6 (forward)
    cmp dword ptr [ebp - local_60], 0x0          # 0049fa34
    jne.d32 L_0049ffb6                           # 0049fa38
    # block 0x0049fa3e: entered by fall-through of jne at 0x0049fa38, 5 instruction(s), ends with jg to 0x0049fa5b (forward)
    mov edx, dword ptr [ebp - local_98]          # 0049fa3e
    sub edx, 0x1                                 # 0049fa44
    mov dword ptr [ebp - local_98], edx          # 0049fa47
    cmp dword ptr [ebp - local_98], 0x0          # 0049fa4d
    jg.d8 L_0049fa5b                             # 0049fa54
    # block 0x0049fa56: entered by fall-through of jg at 0x0049fa54, 1 instruction(s), ends with forward jump to 0x0049ffb6
    jmp.d32 L_0049ffb6                           # 0049fa56
L_0049fa5b:
    # block 0x0049fa5b: entered by jg at 0x0049fa54, 23 instruction(s), calls FUN_0050cd50, ends with jne to 0x0049fabc (forward)
    call FUN_0050cd50                            # 0049fa5b
    mov ecx, dword ptr [ebp - local_a4]          # 0049fa60
    cdq                                          # 0049fa66
    idiv dword ptr [ecx + field_e20]             # 0049fa67
    add edx, dword ptr [ebp + arg_c]             # 0049fa6d
    mov dword ptr [ebp - local_5c], edx          # 0049fa70
    call FUN_0050cd50                            # 0049fa73
    mov ecx, dword ptr [ebp - local_a4]          # 0049fa78
    cdq                                          # 0049fa7e
    idiv dword ptr [ecx + field_e1c]             # 0049fa7f
    add edx, dword ptr [ebp + arg_10]            # 0049fa85
    mov dword ptr [ebp - local_64], edx          # 0049fa88
    mov edx, dword ptr [ebp - local_a4]          # 0049fa8b
    mov eax, dword ptr [ebp - local_5c]          # 0049fa91
    imul eax, dword ptr [edx + field_1c]         # 0049fa94
    mov ecx, dword ptr [ebp - local_a4]          # 0049fa98
    mov edx, dword ptr [ecx + field_e38]         # 0049fa9e
    lea eax, [edx + 4*eax]                       # 0049faa4
    mov ecx, dword ptr [ebp - local_64]          # 0049faa7
    mov edx, dword ptr [eax + 4*ecx]             # 0049faaa
    and edx, 0x1000000                           # 0049faad
    test edx, edx                                # 0049fab3
    jne.d8 L_0049fabc                            # 0049fab5
    # block 0x0049fab7: entered by fall-through of jne at 0x0049fab5, 1 instruction(s), ends with backward jump to 0x0049fa34
    jmp.d32 L_0049fa34                           # 0049fab7
L_0049fabc:
    # block 0x0049fabc: entered by jne at 0x0049fab5, 2 instruction(s), ends with jl to 0x0049faea (forward)
    cmp dword ptr [ebp - local_5c], 0x1          # 0049fabc
    jl.d8 L_0049faea                             # 0049fac0
    # block 0x0049fac2: entered by fall-through of jl at 0x0049fac0, 5 instruction(s), ends with jg to 0x0049faea (forward)
    mov eax, dword ptr [ebp - local_a4]          # 0049fac2
    mov ecx, dword ptr [eax + field_20]          # 0049fac8
    sub ecx, 0x2                                 # 0049facb
    cmp dword ptr [ebp - local_5c], ecx          # 0049face
    jg.d8 L_0049faea                             # 0049fad1
    # block 0x0049fad3: entered by fall-through of jg at 0x0049fad1, 2 instruction(s), ends with jl to 0x0049faea (forward)
    cmp dword ptr [ebp - local_64], 0x1          # 0049fad3
    jl.d8 L_0049faea                             # 0049fad7
    # block 0x0049fad9: entered by fall-through of jl at 0x0049fad7, 5 instruction(s), ends with jle to 0x0049faef (forward)
    mov edx, dword ptr [ebp - local_a4]          # 0049fad9
    mov eax, dword ptr [edx + field_1c]          # 0049fadf
    sub eax, 0x2                                 # 0049fae2
    cmp dword ptr [ebp - local_64], eax          # 0049fae5
    jle.d8 L_0049faef                            # 0049fae8
L_0049faea:
    # block 0x0049faea: entered by jl at 0x0049fac0; jg at 0x0049fad1; jl at 0x0049fad7; fall-through of jle at 0x0049fae8, 1 instruction(s), ends with backward jump to 0x0049fa34
    jmp.d32 L_0049fa34                           # 0049faea
L_0049faef:
    # block 0x0049faef: entered by jle at 0x0049fae8, 4 instruction(s), ends with je to 0x0049fb13 (forward)
    mov ecx, dword ptr [ebp - local_30]          # 0049faef
    mov dword ptr [ebp - local_b0], ecx          # 0049faf2
    cmp dword ptr [ebp - local_b0], 0x0          # 0049faf8
    je.d8 L_0049fb13                             # 0049faff
    # block 0x0049fb01: entered by fall-through of je at 0x0049faff, 2 instruction(s), ends with je to 0x0049fd66 (forward)
    cmp dword ptr [ebp - local_b0], 0x1          # 0049fb01
    je.d32 L_0049fd66                            # 0049fb08
    # block 0x0049fb0e: entered by fall-through of je at 0x0049fb08, 1 instruction(s), ends with forward jump to 0x0049ffb1
    jmp.d32 L_0049ffb1                           # 0049fb0e
L_0049fb13:
    # block 0x0049fb13: entered by je at 0x0049faff, 12 instruction(s), ends with je to 0x0049fc3a (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049fb13
    sub edx, 0x1                                 # 0049fb16
    mov eax, dword ptr [ebp - local_a4]          # 0049fb19
    imul edx, dword ptr [eax + field_1c]         # 0049fb1f
    mov ecx, dword ptr [ebp - local_a4]          # 0049fb23
    mov eax, dword ptr [ecx + field_e38]         # 0049fb29
    lea ecx, [eax + 4*edx]                       # 0049fb2f
    mov edx, dword ptr [ebp - local_64]          # 0049fb32
    mov eax, dword ptr [ecx + 4*edx]             # 0049fb35
    and eax, 0x1000000                           # 0049fb38
    test eax, eax                                # 0049fb3d
    je.d32 L_0049fc3a                            # 0049fb3f
    # block 0x0049fb45: entered by fall-through of je at 0x0049fb3f, 11 instruction(s), ends with je to 0x0049fc3a (forward)
    mov ecx, dword ptr [ebp - local_a4]          # 0049fb45
    mov edx, dword ptr [ebp - local_5c]          # 0049fb4b
    imul edx, dword ptr [ecx + field_1c]         # 0049fb4e
    mov eax, dword ptr [ebp - local_a4]          # 0049fb52
    mov ecx, dword ptr [eax + field_e38]         # 0049fb58
    lea edx, [ecx + 4*edx]                       # 0049fb5e
    mov eax, dword ptr [ebp - local_64]          # 0049fb61
    mov ecx, dword ptr [edx + 4*eax - field_minus_4] # 0049fb64
    and ecx, 0x1000000                           # 0049fb68
    test ecx, ecx                                # 0049fb6e
    je.d32 L_0049fc3a                            # 0049fb70
    # block 0x0049fb76: entered by fall-through of je at 0x0049fb70, 11 instruction(s), ends with je to 0x0049fc3a (forward)
    mov edx, dword ptr [ebp - local_a4]          # 0049fb76
    mov eax, dword ptr [ebp - local_5c]          # 0049fb7c
    imul eax, dword ptr [edx + field_1c]         # 0049fb7f
    mov ecx, dword ptr [ebp - local_a4]          # 0049fb83
    mov edx, dword ptr [ecx + field_e38]         # 0049fb89
    lea eax, [edx + 4*eax]                       # 0049fb8f
    mov ecx, dword ptr [ebp - local_64]          # 0049fb92
    mov edx, dword ptr [eax + 4*ecx + field_4]   # 0049fb95
    and edx, 0x1000000                           # 0049fb99
    test edx, edx                                # 0049fb9f
    je.d32 L_0049fc3a                            # 0049fba1
    # block 0x0049fba7: entered by fall-through of je at 0x0049fba1, 12 instruction(s), ends with je to 0x0049fc3a (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049fba7
    sub eax, 0x1                                 # 0049fbaa
    mov ecx, dword ptr [ebp - local_a4]          # 0049fbad
    imul eax, dword ptr [ecx + field_1c]         # 0049fbb3
    mov edx, dword ptr [ebp - local_a4]          # 0049fbb7
    mov ecx, dword ptr [edx + field_e38]         # 0049fbbd
    lea edx, [ecx + 4*eax]                       # 0049fbc3
    mov eax, dword ptr [ebp - local_64]          # 0049fbc6
    mov ecx, dword ptr [edx + 4*eax - field_minus_4] # 0049fbc9
    and ecx, 0x1000000                           # 0049fbcd
    test ecx, ecx                                # 0049fbd3
    je.d8 L_0049fc3a                             # 0049fbd5
    # block 0x0049fbd7: entered by fall-through of je at 0x0049fbd5, 12 instruction(s), ends with je to 0x0049fc3a (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049fbd7
    sub edx, 0x1                                 # 0049fbda
    mov eax, dword ptr [ebp - local_a4]          # 0049fbdd
    imul edx, dword ptr [eax + field_1c]         # 0049fbe3
    mov ecx, dword ptr [ebp - local_a4]          # 0049fbe7
    mov eax, dword ptr [ecx + field_e38]         # 0049fbed
    lea ecx, [eax + 4*edx]                       # 0049fbf3
    mov edx, dword ptr [ebp - local_64]          # 0049fbf6
    mov eax, dword ptr [ecx + 4*edx + field_4]   # 0049fbf9
    and eax, 0x1000000                           # 0049fbfd
    test eax, eax                                # 0049fc02
    je.d8 L_0049fc3a                             # 0049fc04
    # block 0x0049fc06: entered by fall-through of je at 0x0049fc04, 10 instruction(s), ends with jne to 0x0049fc3a (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 0049fc06
    add ecx, 0x1                                 # 0049fc09
    mov edx, dword ptr [ebp - local_a4]          # 0049fc0c
    imul ecx, dword ptr [edx + field_1c]         # 0049fc12
    mov eax, dword ptr [ebp - local_a4]          # 0049fc16
    mov edx, dword ptr [eax + field_e38]         # 0049fc1c
    lea eax, [edx + 4*ecx]                       # 0049fc22
    mov ecx, dword ptr [ebp - local_64]          # 0049fc25
    cmp dword ptr [eax + 4*ecx], 0x0             # 0049fc28
    jne.d8 L_0049fc3a                            # 0049fc2c
    # block 0x0049fc2e: entered by fall-through of jne at 0x0049fc2c, 2 instruction(s), ends with forward jump to 0x0049ffb1
    mov dword ptr [ebp - local_60], 0x1          # 0049fc2e
    jmp.d32 L_0049ffb1                           # 0049fc35
L_0049fc3a:
    # block 0x0049fc3a: entered by je at 0x0049fb3f; je at 0x0049fb70; je at 0x0049fba1; je at 0x0049fbd5; more, 12 instruction(s), ends with je to 0x0049fd61 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049fc3a
    add edx, 0x1                                 # 0049fc3d
    mov eax, dword ptr [ebp - local_a4]          # 0049fc40
    imul edx, dword ptr [eax + field_1c]         # 0049fc46
    mov ecx, dword ptr [ebp - local_a4]          # 0049fc4a
    mov eax, dword ptr [ecx + field_e38]         # 0049fc50
    lea ecx, [eax + 4*edx]                       # 0049fc56
    mov edx, dword ptr [ebp - local_64]          # 0049fc59
    mov eax, dword ptr [ecx + 4*edx]             # 0049fc5c
    and eax, 0x1000000                           # 0049fc5f
    test eax, eax                                # 0049fc64
    je.d32 L_0049fd61                            # 0049fc66
    # block 0x0049fc6c: entered by fall-through of je at 0x0049fc66, 11 instruction(s), ends with je to 0x0049fd61 (forward)
    mov ecx, dword ptr [ebp - local_a4]          # 0049fc6c
    mov edx, dword ptr [ebp - local_5c]          # 0049fc72
    imul edx, dword ptr [ecx + field_1c]         # 0049fc75
    mov eax, dword ptr [ebp - local_a4]          # 0049fc79
    mov ecx, dword ptr [eax + field_e38]         # 0049fc7f
    lea edx, [ecx + 4*edx]                       # 0049fc85
    mov eax, dword ptr [ebp - local_64]          # 0049fc88
    mov ecx, dword ptr [edx + 4*eax - field_minus_4] # 0049fc8b
    and ecx, 0x1000000                           # 0049fc8f
    test ecx, ecx                                # 0049fc95
    je.d32 L_0049fd61                            # 0049fc97
    # block 0x0049fc9d: entered by fall-through of je at 0x0049fc97, 11 instruction(s), ends with je to 0x0049fd61 (forward)
    mov edx, dword ptr [ebp - local_a4]          # 0049fc9d
    mov eax, dword ptr [ebp - local_5c]          # 0049fca3
    imul eax, dword ptr [edx + field_1c]         # 0049fca6
    mov ecx, dword ptr [ebp - local_a4]          # 0049fcaa
    mov edx, dword ptr [ecx + field_e38]         # 0049fcb0
    lea eax, [edx + 4*eax]                       # 0049fcb6
    mov ecx, dword ptr [ebp - local_64]          # 0049fcb9
    mov edx, dword ptr [eax + 4*ecx + field_4]   # 0049fcbc
    and edx, 0x1000000                           # 0049fcc0
    test edx, edx                                # 0049fcc6
    je.d32 L_0049fd61                            # 0049fcc8
    # block 0x0049fcce: entered by fall-through of je at 0x0049fcc8, 12 instruction(s), ends with je to 0x0049fd61 (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049fcce
    add eax, 0x1                                 # 0049fcd1
    mov ecx, dword ptr [ebp - local_a4]          # 0049fcd4
    imul eax, dword ptr [ecx + field_1c]         # 0049fcda
    mov edx, dword ptr [ebp - local_a4]          # 0049fcde
    mov ecx, dword ptr [edx + field_e38]         # 0049fce4
    lea edx, [ecx + 4*eax]                       # 0049fcea
    mov eax, dword ptr [ebp - local_64]          # 0049fced
    mov ecx, dword ptr [edx + 4*eax - field_minus_4] # 0049fcf0
    and ecx, 0x1000000                           # 0049fcf4
    test ecx, ecx                                # 0049fcfa
    je.d8 L_0049fd61                             # 0049fcfc
    # block 0x0049fcfe: entered by fall-through of je at 0x0049fcfc, 12 instruction(s), ends with je to 0x0049fd61 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049fcfe
    add edx, 0x1                                 # 0049fd01
    mov eax, dword ptr [ebp - local_a4]          # 0049fd04
    imul edx, dword ptr [eax + field_1c]         # 0049fd0a
    mov ecx, dword ptr [ebp - local_a4]          # 0049fd0e
    mov eax, dword ptr [ecx + field_e38]         # 0049fd14
    lea ecx, [eax + 4*edx]                       # 0049fd1a
    mov edx, dword ptr [ebp - local_64]          # 0049fd1d
    mov eax, dword ptr [ecx + 4*edx + field_4]   # 0049fd20
    and eax, 0x1000000                           # 0049fd24
    test eax, eax                                # 0049fd29
    je.d8 L_0049fd61                             # 0049fd2b
    # block 0x0049fd2d: entered by fall-through of je at 0x0049fd2b, 10 instruction(s), ends with jne to 0x0049fd61 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 0049fd2d
    sub ecx, 0x1                                 # 0049fd30
    mov edx, dword ptr [ebp - local_a4]          # 0049fd33
    imul ecx, dword ptr [edx + field_1c]         # 0049fd39
    mov eax, dword ptr [ebp - local_a4]          # 0049fd3d
    mov edx, dword ptr [eax + field_e38]         # 0049fd43
    lea eax, [edx + 4*ecx]                       # 0049fd49
    mov ecx, dword ptr [ebp - local_64]          # 0049fd4c
    cmp dword ptr [eax + 4*ecx], 0x0             # 0049fd4f
    jne.d8 L_0049fd61                            # 0049fd53
    # block 0x0049fd55: entered by fall-through of jne at 0x0049fd53, 2 instruction(s), ends with forward jump to 0x0049ffb1
    mov dword ptr [ebp - local_60], 0x1          # 0049fd55
    jmp.d32 L_0049ffb1                           # 0049fd5c
L_0049fd61:
    # block 0x0049fd61: entered by je at 0x0049fc66; je at 0x0049fc97; je at 0x0049fcc8; je at 0x0049fcfc; more, 1 instruction(s), ends with forward jump to 0x0049ffb1
    jmp.d32 L_0049ffb1                           # 0049fd61
L_0049fd66:
    # block 0x0049fd66: entered by je at 0x0049fb08, 11 instruction(s), ends with je to 0x0049fe8e (forward)
    mov edx, dword ptr [ebp - local_a4]          # 0049fd66
    mov eax, dword ptr [ebp - local_5c]          # 0049fd6c
    imul eax, dword ptr [edx + field_1c]         # 0049fd6f
    mov ecx, dword ptr [ebp - local_a4]          # 0049fd73
    mov edx, dword ptr [ecx + field_e38]         # 0049fd79
    lea eax, [edx + 4*eax]                       # 0049fd7f
    mov ecx, dword ptr [ebp - local_64]          # 0049fd82
    mov edx, dword ptr [eax + 4*ecx - field_minus_4] # 0049fd85
    and edx, 0x1000000                           # 0049fd89
    test edx, edx                                # 0049fd8f
    je.d32 L_0049fe8e                            # 0049fd91
    # block 0x0049fd97: entered by fall-through of je at 0x0049fd91, 12 instruction(s), ends with je to 0x0049fe8e (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049fd97
    sub eax, 0x1                                 # 0049fd9a
    mov ecx, dword ptr [ebp - local_a4]          # 0049fd9d
    imul eax, dword ptr [ecx + field_1c]         # 0049fda3
    mov edx, dword ptr [ebp - local_a4]          # 0049fda7
    mov ecx, dword ptr [edx + field_e38]         # 0049fdad
    lea edx, [ecx + 4*eax]                       # 0049fdb3
    mov eax, dword ptr [ebp - local_64]          # 0049fdb6
    mov ecx, dword ptr [edx + 4*eax]             # 0049fdb9
    and ecx, 0x1000000                           # 0049fdbc
    test ecx, ecx                                # 0049fdc2
    je.d32 L_0049fe8e                            # 0049fdc4
    # block 0x0049fdca: entered by fall-through of je at 0x0049fdc4, 12 instruction(s), ends with je to 0x0049fe8e (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049fdca
    add edx, 0x1                                 # 0049fdcd
    mov eax, dword ptr [ebp - local_a4]          # 0049fdd0
    imul edx, dword ptr [eax + field_1c]         # 0049fdd6
    mov ecx, dword ptr [ebp - local_a4]          # 0049fdda
    mov eax, dword ptr [ecx + field_e38]         # 0049fde0
    lea ecx, [eax + 4*edx]                       # 0049fde6
    mov edx, dword ptr [ebp - local_64]          # 0049fde9
    mov eax, dword ptr [ecx + 4*edx]             # 0049fdec
    and eax, 0x1000000                           # 0049fdef
    test eax, eax                                # 0049fdf4
    je.d32 L_0049fe8e                            # 0049fdf6
    # block 0x0049fdfc: entered by fall-through of je at 0x0049fdf6, 12 instruction(s), ends with je to 0x0049fe8e (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 0049fdfc
    sub ecx, 0x1                                 # 0049fdff
    mov edx, dword ptr [ebp - local_a4]          # 0049fe02
    imul ecx, dword ptr [edx + field_1c]         # 0049fe08
    mov eax, dword ptr [ebp - local_a4]          # 0049fe0c
    mov edx, dword ptr [eax + field_e38]         # 0049fe12
    lea eax, [edx + 4*ecx]                       # 0049fe18
    mov ecx, dword ptr [ebp - local_64]          # 0049fe1b
    mov edx, dword ptr [eax + 4*ecx - field_minus_4] # 0049fe1e
    and edx, 0x1000000                           # 0049fe22
    test edx, edx                                # 0049fe28
    je.d8 L_0049fe8e                             # 0049fe2a
    # block 0x0049fe2c: entered by fall-through of je at 0x0049fe2a, 12 instruction(s), ends with je to 0x0049fe8e (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049fe2c
    add eax, 0x1                                 # 0049fe2f
    mov ecx, dword ptr [ebp - local_a4]          # 0049fe32
    imul eax, dword ptr [ecx + field_1c]         # 0049fe38
    mov edx, dword ptr [ebp - local_a4]          # 0049fe3c
    mov ecx, dword ptr [edx + field_e38]         # 0049fe42
    lea edx, [ecx + 4*eax]                       # 0049fe48
    mov eax, dword ptr [ebp - local_64]          # 0049fe4b
    mov ecx, dword ptr [edx + 4*eax - field_minus_4] # 0049fe4e
    and ecx, 0x1000000                           # 0049fe52
    test ecx, ecx                                # 0049fe58
    je.d8 L_0049fe8e                             # 0049fe5a
    # block 0x0049fe5c: entered by fall-through of je at 0x0049fe5a, 9 instruction(s), ends with jne to 0x0049fe8e (forward)
    mov edx, dword ptr [ebp - local_a4]          # 0049fe5c
    mov eax, dword ptr [ebp - local_5c]          # 0049fe62
    imul eax, dword ptr [edx + field_1c]         # 0049fe65
    mov ecx, dword ptr [ebp - local_a4]          # 0049fe69
    mov edx, dword ptr [ecx + field_e38]         # 0049fe6f
    lea eax, [edx + 4*eax]                       # 0049fe75
    mov ecx, dword ptr [ebp - local_64]          # 0049fe78
    cmp dword ptr [eax + 4*ecx + field_4], 0x0   # 0049fe7b
    jne.d8 L_0049fe8e                            # 0049fe80
    # block 0x0049fe82: entered by fall-through of jne at 0x0049fe80, 2 instruction(s), ends with forward jump to 0x0049ffb1
    mov dword ptr [ebp - local_60], 0x1          # 0049fe82
    jmp.d32 L_0049ffb1                           # 0049fe89
L_0049fe8e:
    # block 0x0049fe8e: entered by je at 0x0049fd91; je at 0x0049fdc4; je at 0x0049fdf6; je at 0x0049fe2a; more, 11 instruction(s), ends with je to 0x0049ffb1 (forward)
    mov edx, dword ptr [ebp - local_a4]          # 0049fe8e
    mov eax, dword ptr [ebp - local_5c]          # 0049fe94
    imul eax, dword ptr [edx + field_1c]         # 0049fe97
    mov ecx, dword ptr [ebp - local_a4]          # 0049fe9b
    mov edx, dword ptr [ecx + field_e38]         # 0049fea1
    lea eax, [edx + 4*eax]                       # 0049fea7
    mov ecx, dword ptr [ebp - local_64]          # 0049feaa
    mov edx, dword ptr [eax + 4*ecx + field_4]   # 0049fead
    and edx, 0x1000000                           # 0049feb1
    test edx, edx                                # 0049feb7
    je.d32 L_0049ffb1                            # 0049feb9
    # block 0x0049febf: entered by fall-through of je at 0x0049feb9, 12 instruction(s), ends with je to 0x0049ffb1 (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049febf
    sub eax, 0x1                                 # 0049fec2
    mov ecx, dword ptr [ebp - local_a4]          # 0049fec5
    imul eax, dword ptr [ecx + field_1c]         # 0049fecb
    mov edx, dword ptr [ebp - local_a4]          # 0049fecf
    mov ecx, dword ptr [edx + field_e38]         # 0049fed5
    lea edx, [ecx + 4*eax]                       # 0049fedb
    mov eax, dword ptr [ebp - local_64]          # 0049fede
    mov ecx, dword ptr [edx + 4*eax]             # 0049fee1
    and ecx, 0x1000000                           # 0049fee4
    test ecx, ecx                                # 0049feea
    je.d32 L_0049ffb1                            # 0049feec
    # block 0x0049fef2: entered by fall-through of je at 0x0049feec, 12 instruction(s), ends with je to 0x0049ffb1 (forward)
    mov edx, dword ptr [ebp - local_5c]          # 0049fef2
    add edx, 0x1                                 # 0049fef5
    mov eax, dword ptr [ebp - local_a4]          # 0049fef8
    imul edx, dword ptr [eax + field_1c]         # 0049fefe
    mov ecx, dword ptr [ebp - local_a4]          # 0049ff02
    mov eax, dword ptr [ecx + field_e38]         # 0049ff08
    lea ecx, [eax + 4*edx]                       # 0049ff0e
    mov edx, dword ptr [ebp - local_64]          # 0049ff11
    mov eax, dword ptr [ecx + 4*edx]             # 0049ff14
    and eax, 0x1000000                           # 0049ff17
    test eax, eax                                # 0049ff1c
    je.d32 L_0049ffb1                            # 0049ff1e
    # block 0x0049ff24: entered by fall-through of je at 0x0049ff1e, 12 instruction(s), ends with je to 0x0049ffb1 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 0049ff24
    sub ecx, 0x1                                 # 0049ff27
    mov edx, dword ptr [ebp - local_a4]          # 0049ff2a
    imul ecx, dword ptr [edx + field_1c]         # 0049ff30
    mov eax, dword ptr [ebp - local_a4]          # 0049ff34
    mov edx, dword ptr [eax + field_e38]         # 0049ff3a
    lea eax, [edx + 4*ecx]                       # 0049ff40
    mov ecx, dword ptr [ebp - local_64]          # 0049ff43
    mov edx, dword ptr [eax + 4*ecx + field_4]   # 0049ff46
    and edx, 0x1000000                           # 0049ff4a
    test edx, edx                                # 0049ff50
    je.d8 L_0049ffb1                             # 0049ff52
    # block 0x0049ff54: entered by fall-through of je at 0x0049ff52, 12 instruction(s), ends with je to 0x0049ffb1 (forward)
    mov eax, dword ptr [ebp - local_5c]          # 0049ff54
    add eax, 0x1                                 # 0049ff57
    mov ecx, dword ptr [ebp - local_a4]          # 0049ff5a
    imul eax, dword ptr [ecx + field_1c]         # 0049ff60
    mov edx, dword ptr [ebp - local_a4]          # 0049ff64
    mov ecx, dword ptr [edx + field_e38]         # 0049ff6a
    lea edx, [ecx + 4*eax]                       # 0049ff70
    mov eax, dword ptr [ebp - local_64]          # 0049ff73
    mov ecx, dword ptr [edx + 4*eax + field_4]   # 0049ff76
    and ecx, 0x1000000                           # 0049ff7a
    test ecx, ecx                                # 0049ff80
    je.d8 L_0049ffb1                             # 0049ff82
    # block 0x0049ff84: entered by fall-through of je at 0x0049ff82, 9 instruction(s), ends with jne to 0x0049ffb1 (forward)
    mov edx, dword ptr [ebp - local_a4]          # 0049ff84
    mov eax, dword ptr [ebp - local_5c]          # 0049ff8a
    imul eax, dword ptr [edx + field_1c]         # 0049ff8d
    mov ecx, dword ptr [ebp - local_a4]          # 0049ff91
    mov edx, dword ptr [ecx + field_e38]         # 0049ff97
    lea eax, [edx + 4*eax]                       # 0049ff9d
    mov ecx, dword ptr [ebp - local_64]          # 0049ffa0
    cmp dword ptr [eax + 4*ecx - field_minus_4], 0x0 # 0049ffa3
    jne.d8 L_0049ffb1                            # 0049ffa8
    # block 0x0049ffaa: entered by fall-through of jne at 0x0049ffa8, 1 instruction(s), falls into the block at 0x0049ffb1
    mov dword ptr [ebp - local_60], 0x1          # 0049ffaa
L_0049ffb1:
    # block 0x0049ffb1: entered by jmp at 0x0049fb0e; jmp at 0x0049fc35; jmp at 0x0049fd5c; jmp at 0x0049fd61; more, 1 instruction(s), ends with backward jump to 0x0049fa34
    jmp.d32 L_0049fa34                           # 0049ffb1
L_0049ffb6:
    # block 0x0049ffb6: entered by jne at 0x0049fa38; jmp at 0x0049fa56, 2 instruction(s), ends with je to 0x004a0358 (forward)
    cmp dword ptr [ebp - local_60], 0x0          # 0049ffb6
    je.d32 L_004a0358                            # 0049ffba
    # block 0x0049ffc0: entered by fall-through of je at 0x0049ffba, 31 instruction(s), calls FUN_0050cd50, ends with jge to 0x004a004a (forward)
    call FUN_0050cd50                            # 0049ffc0
    cdq                                          # 0049ffc5
    idiv dword ptr [ebp - local_a0]              # 0049ffc6
    mov dword ptr [ebp - local_2c], edx          # 0049ffcc
    mov edx, dword ptr [ebp - local_2c]          # 0049ffcf
    mov eax, dword ptr [ebp + 4*edx - local_28]  # 0049ffd2
    mov dword ptr [ebp - local_9c], eax          # 0049ffd6
    mov ecx, dword ptr [ebp - local_2c]          # 0049ffdc
    mov dx, word ptr [ebp + 2*ecx - local_94]    # 0049ffdf
    mov word ptr [ebp - local_68], dx            # 0049ffe7
    mov dword ptr [ebp - local_40], 0x0          # 0049ffeb
    mov eax, dword ptr [ebp - local_40]          # 0049fff2
    mov dword ptr [ebp - local_80], eax          # 0049fff5
    mov ecx, dword ptr [ebp - local_80]          # 0049fff8
    mov dword ptr [ebp - local_4c], ecx          # 0049fffb
    mov edx, dword ptr [ebp - local_9c]          # 0049fffe
    shr edx, 0x10                                # 004a0004
    and edx, 0xff                                # 004a0007
    mov dword ptr [ebp - local_4c], edx          # 004a000d
    mov eax, dword ptr [ebp - local_9c]          # 004a0010
    shr eax, 0x8                                 # 004a0016
    and eax, 0xff                                # 004a0019
    mov dword ptr [ebp - local_80], eax          # 004a001e
    mov ecx, dword ptr [ebp - local_9c]          # 004a0021
    and ecx, 0xff                                # 004a0027
    mov dword ptr [ebp - local_40], ecx          # 004a002d
    movsx edx, word ptr [ebp - local_68]         # 004a0030
    mov eax, dword ptr [ebp - local_3c]          # 004a0034
    sub eax, 0x1                                 # 004a0037
    {load} cmp edx, eax                          # 004a003a
    jge.d8 L_004a004a                            # 004a003c
    # block 0x004a003e: entered by fall-through of jge at 0x004a003c, 3 instruction(s), ends with forward jump to 0x004a0056
    movsx ecx, word ptr [ebp - local_68]         # 004a003e
    mov dword ptr [ebp - local_b4], ecx          # 004a0042
    jmp.d8 L_004a0056                            # 004a0048
L_004a004a:
    # block 0x004a004a: entered by jge at 0x004a003c, 3 instruction(s), falls into the block at 0x004a0056
    mov edx, dword ptr [ebp - local_3c]          # 004a004a
    sub edx, 0x1                                 # 004a004d
    mov dword ptr [ebp - local_b4], edx          # 004a0050
L_004a0056:
    # block 0x004a0056: entered by jmp at 0x004a0048, 7 instruction(s), ends with je to 0x004a00a1 (forward)
    mov ax, word ptr [ebp - local_b4]            # 004a0056
    mov word ptr [ebp - local_68], ax            # 004a005d
    mov ecx, dword ptr [ebp - local_9c]          # 004a0061
    and ecx, 0xffffff                            # 004a0067
    mov dword ptr [ebp - local_9c], ecx          # 004a006d
    cmp dword ptr [ebp - local_40], 0x0          # 004a0073
    je.d8 L_004a00a1                             # 004a0077
    # block 0x004a0079: entered by fall-through of je at 0x004a0077, 2 instruction(s), ends with jne to 0x004a008b (forward)
    cmp dword ptr [ebp - local_80], 0x0          # 004a0079
    jne.d8 L_004a008b                            # 004a007d
    # block 0x004a007f: entered by fall-through of jne at 0x004a007d, 3 instruction(s), ends with jg to 0x004a00a1 (forward)
    movsx edx, word ptr [ebp - local_68]         # 004a007f
    cmp edx, dword ptr [0x6329d5]                # 004a0083
    jg.d8 L_004a00a1                             # 004a0089
L_004a008b:
    # block 0x004a008b: entered by jne at 0x004a007d; fall-through of jg at 0x004a0089, 2 instruction(s), ends with jne to 0x004a00b3 (forward)
    cmp dword ptr [ebp - local_4c], 0x0          # 004a008b
    jne.d8 L_004a00b3                            # 004a008f
    # block 0x004a0091: entered by fall-through of jne at 0x004a008f, 5 instruction(s), ends with jle to 0x004a00b3 (forward)
    movsx eax, word ptr [ebp - local_68]         # 004a0091
    mov ecx, dword ptr [0x6329d5]                # 004a0095
    shl ecx                                      # 004a009b
    {load} cmp eax, ecx                          # 004a009d
    jle.d8 L_004a00b3                            # 004a009f
L_004a00a1:
    # block 0x004a00a1: entered by je at 0x004a0077; jg at 0x004a0089; fall-through of jle at 0x004a009f, 3 instruction(s), falls into the block at 0x004a00b3
    mov edx, dword ptr [ebp - local_9c]          # 004a00a1
    or edx, 0x10000000                           # 004a00a7
    mov dword ptr [ebp - local_9c], edx          # 004a00ad
L_004a00b3:
    # block 0x004a00b3: entered by jne at 0x004a008f; jle at 0x004a009f, 5 instruction(s), ends with jne to 0x004a00de (forward)
    mov eax, dword ptr [ebp - local_9c]          # 004a00b3
    or eax, 0x20000000                           # 004a00b9
    mov dword ptr [ebp - local_9c], eax          # 004a00be
    cmp dword ptr [ebp - local_30], 0x0          # 004a00c4
    jne.d8 L_004a00de                            # 004a00c8
    # block 0x004a00ca: entered by fall-through of jne at 0x004a00c8, 4 instruction(s), ends with forward jump to 0x004a00f0
    mov ecx, dword ptr [ebp - local_9c]          # 004a00ca
    or ecx, 0x2000000                            # 004a00d0
    mov dword ptr [ebp - local_9c], ecx          # 004a00d6
    jmp.d8 L_004a00f0                            # 004a00dc
L_004a00de:
    # block 0x004a00de: entered by jne at 0x004a00c8, 3 instruction(s), falls into the block at 0x004a00f0
    mov edx, dword ptr [ebp - local_9c]          # 004a00de
    or edx, 0x4000000                            # 004a00e4
    mov dword ptr [ebp - local_9c], edx          # 004a00ea
L_004a00f0:
    # block 0x004a00f0: entered by jmp at 0x004a00dc, 168 instruction(s), ends with forward jump to 0x004a035a
    mov eax, dword ptr [ebp - local_a4]          # 004a00f0
    mov ecx, dword ptr [ebp - local_5c]          # 004a00f6
    imul ecx, dword ptr [eax + field_1c]         # 004a00f9
    mov edx, dword ptr [ebp - local_a4]          # 004a00fd
    mov eax, dword ptr [edx + field_e38]         # 004a0103
    lea ecx, [eax + 4*ecx]                       # 004a0109
    mov edx, dword ptr [ebp - local_64]          # 004a010c
    mov eax, dword ptr [ebp - local_9c]          # 004a010f
    mov dword ptr [ecx + 4*edx], eax             # 004a0115
    mov ecx, dword ptr [ebp - local_a4]          # 004a0118
    mov edx, dword ptr [ebp - local_5c]          # 004a011e
    imul edx, dword ptr [ecx + field_1c]         # 004a0121
    mov eax, dword ptr [ebp - local_a4]          # 004a0125
    mov ecx, dword ptr [eax + field_e48]         # 004a012b
    lea edx, [ecx + 2*edx]                       # 004a0131
    mov eax, dword ptr [ebp - local_64]          # 004a0134
    mov cx, word ptr [ebp - local_68]            # 004a0137
    mov word ptr [edx + 2*eax], cx               # 004a013b
    mov dword ptr [ebp - local_44], 0x0          # 004a013f
    mov edx, dword ptr [ebp - local_44]          # 004a0146
    mov dword ptr [ebp - local_6c], edx          # 004a0149
    mov eax, dword ptr [ebp - local_6c]          # 004a014c
    mov dword ptr [ebp - local_7c], eax          # 004a014f
    mov cx, word ptr [ebp - local_7c]            # 004a0152
    mov word ptr [ebp - local_48], cx            # 004a0156
    mov edx, dword ptr [ebp - local_a4]          # 004a015a
    mov eax, dword ptr [ebp - local_5c]          # 004a0160
    imul eax, dword ptr [edx + field_1c]         # 004a0163
    mov ecx, dword ptr [ebp - local_a4]          # 004a0167
    mov edx, dword ptr [ecx + field_e40]         # 004a016d
    lea eax, [edx + 2*eax]                       # 004a0173
    mov ecx, dword ptr [ebp - local_64]          # 004a0176
    mov dx, word ptr [eax + 2*ecx]               # 004a0179
    mov word ptr [ebp - local_48], dx            # 004a017d
    mov eax, dword ptr [ebp - local_48]          # 004a0181
    and eax, 0xffff                              # 004a0184
    sar eax, 0x8                                 # 004a0189
    and eax, 0xf                                 # 004a018c
    mov dword ptr [ebp - local_7c], eax          # 004a018f
    mov ecx, dword ptr [ebp - local_48]          # 004a0192
    and ecx, 0xffff                              # 004a0195
    sar ecx, 0x4                                 # 004a019b
    and ecx, 0xf                                 # 004a019e
    mov dword ptr [ebp - local_6c], ecx          # 004a01a1
    mov edx, dword ptr [ebp - local_48]          # 004a01a4
    and edx, 0xffff                              # 004a01a7
    and edx, 0xf                                 # 004a01ad
    mov dword ptr [ebp - local_44], edx          # 004a01b0
    mov eax, dword ptr [ebp - local_48]          # 004a01b3
    and eax, 0xffff                              # 004a01b6
    and eax, 0xf000                              # 004a01bb
    mov word ptr [ebp - local_70], ax            # 004a01c0
    mov ecx, dword ptr [ebp - local_7c]          # 004a01c4
    sub ecx, 0x2                                 # 004a01c7
    mov dword ptr [ebp - local_7c], ecx          # 004a01ca
    mov edx, dword ptr [ebp - local_6c]          # 004a01cd
    sub edx, 0x2                                 # 004a01d0
    mov dword ptr [ebp - local_6c], edx          # 004a01d3
    mov eax, dword ptr [ebp - local_44]          # 004a01d6
    sub eax, 0x2                                 # 004a01d9
    mov dword ptr [ebp - local_44], eax          # 004a01dc
    {load} xor ecx, ecx                          # 004a01df
    cmp dword ptr [ebp - local_7c], 0x0          # 004a01e1
    setle cl                                     # 004a01e5
    dec ecx                                      # 004a01e8
    and ecx, dword ptr [ebp - local_7c]          # 004a01e9
    mov dword ptr [ebp - local_7c], ecx          # 004a01ec
    {load} xor edx, edx                          # 004a01ef
    cmp dword ptr [ebp - local_6c], 0x0          # 004a01f1
    setle dl                                     # 004a01f5
    dec edx                                      # 004a01f8
    and edx, dword ptr [ebp - local_6c]          # 004a01f9
    mov dword ptr [ebp - local_6c], edx          # 004a01fc
    {load} xor eax, eax                          # 004a01ff
    cmp dword ptr [ebp - local_44], 0x0          # 004a0201
    setle al                                     # 004a0205
    dec eax                                      # 004a0208
    and eax, dword ptr [ebp - local_44]          # 004a0209
    mov dword ptr [ebp - local_44], eax          # 004a020c
    mov ecx, dword ptr [ebp - local_7c]          # 004a020f
    shl ecx, 0x8                                 # 004a0212
    mov dword ptr [ebp - local_7c], ecx          # 004a0215
    mov edx, dword ptr [ebp - local_6c]          # 004a0218
    shl edx, 0x4                                 # 004a021b
    mov dword ptr [ebp - local_6c], edx          # 004a021e
    mov word ptr [ebp - local_48], 0x0           # 004a0221
    mov eax, dword ptr [ebp - local_70]          # 004a0227
    and eax, 0xffff                              # 004a022a
    or eax, dword ptr [ebp - local_7c]           # 004a022f
    or eax, dword ptr [ebp - local_6c]           # 004a0232
    or eax, dword ptr [ebp - local_44]           # 004a0235
    mov word ptr [ebp - local_48], ax            # 004a0238
    mov ecx, dword ptr [ebp - local_a4]          # 004a023c
    mov edx, dword ptr [ebp - local_5c]          # 004a0242
    imul edx, dword ptr [ecx + field_1c]         # 004a0245
    mov eax, dword ptr [ebp - local_a4]          # 004a0249
    mov ecx, dword ptr [eax + field_e40]         # 004a024f
    lea edx, [ecx + 2*edx]                       # 004a0255
    mov eax, dword ptr [ebp - local_64]          # 004a0258
    mov cx, word ptr [ebp - local_48]            # 004a025b
    mov word ptr [edx + 2*eax], cx               # 004a025f
    mov dword ptr [ebp - local_78], 0x0          # 004a0263
    mov edx, dword ptr [ebp - local_78]          # 004a026a
    mov dword ptr [ebp - local_38], edx          # 004a026d
    mov ax, word ptr [ebp - local_38]            # 004a0270
    mov word ptr [ebp - local_50], ax            # 004a0274
    mov ecx, dword ptr [ebp - local_a4]          # 004a0278
    mov edx, dword ptr [ebp - local_5c]          # 004a027e
    imul edx, dword ptr [ecx + field_1c]         # 004a0281
    mov eax, dword ptr [ebp - local_a4]          # 004a0285
    mov ecx, dword ptr [eax + field_e44]         # 004a028b
    lea edx, [ecx + 2*edx]                       # 004a0291
    mov eax, dword ptr [ebp - local_64]          # 004a0294
    mov cx, word ptr [edx + 2*eax]               # 004a0297
    mov word ptr [ebp - local_50], cx            # 004a029b
    mov edx, dword ptr [ebp - local_50]          # 004a029f
    and edx, 0xffff                              # 004a02a2
    sar edx, 0x4                                 # 004a02a8
    and edx, 0xf                                 # 004a02ab
    mov dword ptr [ebp - local_78], edx          # 004a02ae
    mov eax, dword ptr [ebp - local_50]          # 004a02b1
    and eax, 0xffff                              # 004a02b4
    and eax, 0xf                                 # 004a02b9
    mov dword ptr [ebp - local_38], eax          # 004a02bc
    mov ecx, dword ptr [ebp - local_50]          # 004a02bf
    and ecx, 0xffff                              # 004a02c2
    and ecx, 0xf000                              # 004a02c8
    mov word ptr [ebp - local_70], cx            # 004a02ce
    mov edx, dword ptr [ebp - local_78]          # 004a02d2
    sub edx, 0x2                                 # 004a02d5
    mov dword ptr [ebp - local_78], edx          # 004a02d8
    mov eax, dword ptr [ebp - local_38]          # 004a02db
    sub eax, 0x2                                 # 004a02de
    mov dword ptr [ebp - local_38], eax          # 004a02e1
    {load} xor ecx, ecx                          # 004a02e4
    cmp dword ptr [ebp - local_78], 0x0          # 004a02e6
    setle cl                                     # 004a02ea
    dec ecx                                      # 004a02ed
    and ecx, dword ptr [ebp - local_78]          # 004a02ee
    mov dword ptr [ebp - local_78], ecx          # 004a02f1
    {load} xor edx, edx                          # 004a02f4
    cmp dword ptr [ebp - local_38], 0x0          # 004a02f6
    setle dl                                     # 004a02fa
    dec edx                                      # 004a02fd
    and edx, dword ptr [ebp - local_38]          # 004a02fe
    mov dword ptr [ebp - local_38], edx          # 004a0301
    mov eax, dword ptr [ebp - local_78]          # 004a0304
    shl eax, 0x4                                 # 004a0307
    mov dword ptr [ebp - local_78], eax          # 004a030a
    mov word ptr [ebp - local_50], 0x0           # 004a030d
    mov ecx, dword ptr [ebp - local_70]          # 004a0313
    and ecx, 0xffff                              # 004a0316
    or ecx, dword ptr [ebp - local_78]           # 004a031c
    or ecx, dword ptr [ebp - local_38]           # 004a031f
    mov word ptr [ebp - local_50], cx            # 004a0322
    mov edx, dword ptr [ebp - local_a4]          # 004a0326
    mov eax, dword ptr [ebp - local_5c]          # 004a032c
    imul eax, dword ptr [edx + field_1c]         # 004a032f
    mov ecx, dword ptr [ebp - local_a4]          # 004a0333
    mov edx, dword ptr [ecx + field_e44]         # 004a0339
    lea eax, [edx + 2*eax]                       # 004a033f
    mov ecx, dword ptr [ebp - local_64]          # 004a0342
    mov dx, word ptr [ebp - local_50]            # 004a0345
    mov word ptr [eax + 2*ecx], dx               # 004a0349
    mov eax, dword ptr [ebp - local_34]          # 004a034d
    add eax, 0x1                                 # 004a0350
    mov dword ptr [ebp - local_34], eax          # 004a0353
    jmp.d8 L_004a035a                            # 004a0356
L_004a0358:
    # block 0x004a0358: entered by je at 0x0049ffba, 1 instruction(s), ends with forward jump to 0x004a035f
    jmp.d8 L_004a035f                            # 004a0358
L_004a035a:
    # block 0x004a035a: entered by jmp at 0x004a0356, 1 instruction(s), ends with backward jump to 0x0049f9f0
    jmp.d32 L_0049f9f0                           # 004a035a
L_004a035f:
    # block 0x004a035f: entered by jge at 0x0049f9f6; jmp at 0x004a0358, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004a035f
    pop ebp                                      # 004a0361
    ret 0xc                                      # 004a0362

