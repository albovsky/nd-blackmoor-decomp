# FUN_004477d1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004477d1
# extent:       0x004477d1-0x00447ac7 (758 code bytes)
# span:         0x004477d1-0x00447ac7 (code 758, tables 0, padding 0)
# sha256:       be28d4a5f9c6e9c5273ac3ab8a1a0bf326230e34d15e67e9d81d13ec64b4d182
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004477d1
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x14 (callee pops 20 bytes); ecx is not read in the entry block before being written
# locals:       23 ebp-relative slot(s): local_4, local_8, local_60, local_74, local_84, local_4084, local_4088, local_408c, local_4090, local_4094, local_4098, local_409c and 11 more
# fields:       [eax + n] field_4, field_8, field_25, field_29, field_3d; [ecx + n] field_4, field_8, field_1d, field_21; [edx + n] field_4e, field_52
# callees:      calls FUN_0050c920, FUN_004c3efb, FUN_0050ce04, FUN_004c4202, FUN_004c952f, FUN_004c4c2b
# track-n:      outputs/blackmoor-decomp/src/action_family_28.h:action_family28_blend_pixels (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 176 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_60, 0x60  # offset -0x60
.equ local_74, 0x74  # offset -0x74
.equ local_84, 0x84  # offset -0x84
.equ local_4084, 0x4084  # offset -0x4084
.equ local_4088, 0x4088  # offset -0x4088
.equ local_408c, 0x408c  # offset -0x408c
.equ local_4090, 0x4090  # offset -0x4090
.equ local_4094, 0x4094  # offset -0x4094
.equ local_4098, 0x4098  # offset -0x4098
.equ local_409c, 0x409c  # offset -0x409c
.equ local_40a0, 0x40a0  # offset -0x40a0
.equ local_40a4, 0x40a4  # offset -0x40a4
.equ local_40a8, 0x40a8  # offset -0x40a8
.equ local_40ac, 0x40ac  # offset -0x40ac
.equ local_40b0, 0x40b0  # offset -0x40b0
.equ local_40b4, 0x40b4  # offset -0x40b4
.equ local_40b8, 0x40b8  # offset -0x40b8
.equ local_40bc, 0x40bc  # offset -0x40bc
.equ local_40c4, 0x40c4  # offset -0x40c4
.equ local_40c8, 0x40c8  # offset -0x40c8
.equ local_40d0, 0x40d0  # offset -0x40d0
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_1d, 0x1d  # offset +0x1d
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_3d, 0x3d  # offset +0x3d
.equ field_4e, 0x4e  # offset +0x4e
.equ field_52, 0x52  # offset +0x52

# --- external targets -----------------------------------------------
.set FUN_004c3efb, .text + (0x004c3efb - 0x401000)
.set FUN_004c4202, .text + (0x004c4202 - 0x401000)
.set FUN_004c4c2b, .text + (0x004c4c2b - 0x401000)
.set FUN_004c952f, .text + (0x004c952f - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004477d1 - 0x401000
.globl FUN_004477d1
FUN_004477d1:
    # block 0x004477d1: entry, 41 instruction(s), calls FUN_0050c920, FUN_004c3efb, ends with forward jump to 0x0044788b
    push ebp                                     # 004477d1
    {load} mov ebp, esp                          # 004477d2
    mov eax, 0x40d0                              # 004477d4
    call FUN_0050c920                            # 004477d9
    push esi                                     # 004477de
    mov dword ptr [ebp - local_40bc], ecx        # 004477df
    mov eax, dword ptr [ebp - local_40bc]        # 004477e5
    mov ecx, dword ptr [ebp - local_40bc]        # 004477eb
    mov edx, dword ptr [eax + field_29]          # 004477f1
    sub edx, dword ptr [ecx + field_21]          # 004477f4
    add edx, 0x1                                 # 004477f7
    mov dword ptr [ebp - local_409c], edx        # 004477fa
    mov eax, dword ptr [ebp - local_40bc]        # 00447800
    mov ecx, dword ptr [ebp - local_40bc]        # 00447806
    mov edx, dword ptr [eax + field_25]          # 0044780c
    sub edx, dword ptr [ecx + field_1d]          # 0044780f
    add edx, 0x1                                 # 00447812
    mov dword ptr [ebp - local_4088], edx        # 00447815
    push 0x548540                                # 0044781b
    lea eax, [ebp - local_84]                    # 00447820
    push eax                                     # 00447826
    mov ecx, dword ptr [ebp - local_40bc]        # 00447827
    add ecx, 0x1d                                # 0044782d
    push ecx                                     # 00447830
    mov edx, dword ptr [ebp + arg_8]             # 00447831
    push edx                                     # 00447834
    mov ecx, 0x5cf659                            # 00447835
    call FUN_004c3efb                            # 0044783a
    mov eax, dword ptr [ebp - local_60]          # 0044783f
    mov dword ptr [ebp - local_4], eax           # 00447842
    mov ecx, dword ptr [ebp - local_74]          # 00447845
    mov dword ptr [ebp - local_4090], ecx        # 00447848
    mov edx, dword ptr [ebp - local_40bc]        # 0044784e
    mov eax, dword ptr [ebp - local_40bc]        # 00447854
    mov ecx, dword ptr [edx + field_52]          # 0044785a
    imul ecx, dword ptr [eax + field_3d]         # 0044785d
    mov edx, dword ptr [ebp - local_40bc]        # 00447861
    add ecx, dword ptr [edx + field_4e]          # 00447867
    mov dword ptr [ebp - local_40a0], ecx        # 0044786a
    mov dword ptr [ebp - local_408c], 0x0        # 00447870
    jmp.d8 L_0044788b                            # 0044787a
L_0044787c:
    # block 0x0044787c: entered by jmp at 0x0044791b, 3 instruction(s), falls into the block at 0x0044788b
    mov eax, dword ptr [ebp - local_408c]        # 0044787c
    add eax, 0x1                                 # 00447882
    mov dword ptr [ebp - local_408c], eax        # 00447885
L_0044788b:
    # block 0x0044788b: entered by jmp at 0x0044787a, 2 instruction(s), ends with jge to 0x00447920 (forward)
    cmp dword ptr [ebp - local_408c], 0x40       # 0044788b
    jge.d32 L_00447920                           # 00447892
    # block 0x00447898: entered by fall-through of jge at 0x00447892, 2 instruction(s), ends with forward jump to 0x004478b3
    mov dword ptr [ebp - local_4098], 0x0        # 00447898
    jmp.d8 L_004478b3                            # 004478a2
L_004478a4:
    # block 0x004478a4: entered by jmp at 0x00447919, 3 instruction(s), falls into the block at 0x004478b3
    mov ecx, dword ptr [ebp - local_4098]        # 004478a4
    add ecx, 0x1                                 # 004478aa
    mov dword ptr [ebp - local_4098], ecx        # 004478ad
L_004478b3:
    # block 0x004478b3: entered by jmp at 0x004478a2, 2 instruction(s), ends with jge to 0x0044791b (forward)
    cmp dword ptr [ebp - local_4098], 0x40       # 004478b3
    jge.d8 L_0044791b                            # 004478ba
    # block 0x004478bc: entered by fall-through of jge at 0x004478ba, 18 instruction(s), calls FUN_0050ce04, ends with backward jump to 0x004478a4
    fild dword ptr [ebp - local_4098]            # 004478bc
    fstp qword ptr [ebp - local_40c4]            # 004478c2
    mov edx, dword ptr [ebp - local_408c]        # 004478c8
    sub edx, dword ptr [ebp - local_4098]        # 004478ce
    mov dword ptr [ebp - local_40c8], edx        # 004478d4
    fild dword ptr [ebp - local_40c8]            # 004478da
    fstp qword ptr [ebp - local_40d0]            # 004478e0
    fld qword ptr [ebp - local_40d0]             # 004478e6
    fmul qword ptr [ebp + arg_14]                # 004478ec
    fadd qword ptr [0x52cac0]                    # 004478ef
    fadd qword ptr [ebp - local_40c4]            # 004478f5
    call FUN_0050ce04                            # 004478fb
    mov ecx, dword ptr [ebp - local_408c]        # 00447900
    shl ecx, 0x8                                 # 00447906
    lea edx, [ebp + ecx - local_4084]            # 00447909
    mov ecx, dword ptr [ebp - local_4098]        # 00447910
    mov dword ptr [edx + 4*ecx], eax             # 00447916
    jmp.d8 L_004478a4                            # 00447919
L_0044791b:
    # block 0x0044791b: entered by jge at 0x004478ba, 1 instruction(s), ends with backward jump to 0x0044787c
    jmp.d32 L_0044787c                           # 0044791b
L_00447920:
    # block 0x00447920: entered by jge at 0x00447892, 2 instruction(s), ends with forward jump to 0x0044793b
    mov dword ptr [ebp - local_4094], 0x0        # 00447920
    jmp.d8 L_0044793b                            # 0044792a
L_0044792c:
    # block 0x0044792c: entered by jmp at 0x00447a75, 3 instruction(s), falls into the block at 0x0044793b
    mov edx, dword ptr [ebp - local_4094]        # 0044792c
    add edx, 0x1                                 # 00447932
    mov dword ptr [ebp - local_4094], edx        # 00447935
L_0044793b:
    # block 0x0044793b: entered by jmp at 0x0044792a, 3 instruction(s), ends with jge to 0x00447a7a (forward)
    mov eax, dword ptr [ebp - local_4094]        # 0044793b
    cmp eax, dword ptr [ebp - local_409c]        # 00447941
    jge.d32 L_00447a7a                           # 00447947
    # block 0x0044794d: entered by fall-through of jge at 0x00447947, 2 instruction(s), ends with forward jump to 0x0044795f
    mov dword ptr [ebp - local_8], 0x0           # 0044794d
    jmp.d8 L_0044795f                            # 00447954
L_00447956:
    # block 0x00447956: entered by jmp at 0x00447a47, 3 instruction(s), falls into the block at 0x0044795f
    mov ecx, dword ptr [ebp - local_8]           # 00447956
    add ecx, 0x2                                 # 00447959
    mov dword ptr [ebp - local_8], ecx           # 0044795c
L_0044795f:
    # block 0x0044795f: entered by jmp at 0x00447954, 4 instruction(s), ends with jge to 0x00447a4c (forward)
    mov edx, dword ptr [ebp - local_4088]        # 0044795f
    shl edx                                      # 00447965
    cmp dword ptr [ebp - local_8], edx           # 00447967
    jge.d32 L_00447a4c                           # 0044796a
    # block 0x00447970: entered by fall-through of jge at 0x0044796a, 55 instruction(s), ends with backward jump to 0x00447956
    mov eax, dword ptr [ebp - local_40a0]        # 00447970
    imul eax, eax, 0xc                           # 00447976
    mov ecx, dword ptr [ebp + arg_c]             # 00447979
    {load} add ecx, eax                          # 0044797c
    mov edx, dword ptr [ecx]                     # 0044797e
    mov dword ptr [ebp - local_40b8], edx        # 00447980
    mov eax, dword ptr [ecx + field_4]           # 00447986
    mov dword ptr [ebp - local_40b4], eax        # 00447989
    mov ecx, dword ptr [ecx + field_8]           # 0044798f
    mov dword ptr [ebp - local_40b0], ecx        # 00447992
    mov edx, dword ptr [ebp - local_40a0]        # 00447998
    imul edx, edx, 0xc                           # 0044799e
    mov eax, dword ptr [ebp + arg_10]            # 004479a1
    {load} add eax, edx                          # 004479a4
    mov ecx, dword ptr [eax]                     # 004479a6
    mov dword ptr [ebp - local_40ac], ecx        # 004479a8
    mov edx, dword ptr [eax + field_4]           # 004479ae
    mov dword ptr [ebp - local_40a8], edx        # 004479b1
    mov eax, dword ptr [eax + field_8]           # 004479b7
    mov dword ptr [ebp - local_40a4], eax        # 004479ba
    mov ecx, dword ptr [ebp - local_40b8]        # 004479c0
    shl ecx, 0x8                                 # 004479c6
    lea edx, [ebp + ecx - local_4084]            # 004479c9
    {load} xor eax, eax                          # 004479d0
    mov al, byte ptr [0x5d2f1b]                  # 004479d2
    {load} mov ecx, eax                          # 004479d7
    mov eax, dword ptr [ebp - local_40ac]        # 004479d9
    mov edx, dword ptr [edx + 4*eax]             # 004479df
    shl edx, cl                                  # 004479e2
    mov eax, dword ptr [ebp - local_40b4]        # 004479e4
    shl eax, 0x8                                 # 004479ea
    lea ecx, [ebp + eax - local_4084]            # 004479ed
    {load} xor eax, eax                          # 004479f4
    mov al, byte ptr [0x5d2f1a]                  # 004479f6
    mov esi, dword ptr [ebp - local_40a8]        # 004479fb
    mov esi, dword ptr [ecx + 4*esi]             # 00447a01
    {load} mov ecx, eax                          # 00447a04
    shl esi, cl                                  # 00447a06
    {load} or edx, esi                           # 00447a08
    mov ecx, dword ptr [ebp - local_40b0]        # 00447a0a
    shl ecx, 0x8                                 # 00447a10
    lea eax, [ebp + ecx - local_4084]            # 00447a13
    {load} xor ecx, ecx                          # 00447a1a
    mov cl, byte ptr [0x5d2f19]                  # 00447a1c
    mov esi, dword ptr [ebp - local_40a4]        # 00447a22
    mov eax, dword ptr [eax + 4*esi]             # 00447a28
    shl eax, cl                                  # 00447a2b
    {load} or edx, eax                           # 00447a2d
    mov ecx, dword ptr [ebp - local_4]           # 00447a2f
    add ecx, dword ptr [ebp - local_8]           # 00447a32
    mov word ptr [ecx], dx                       # 00447a35
    mov edx, dword ptr [ebp - local_40a0]        # 00447a38
    add edx, 0x1                                 # 00447a3e
    mov dword ptr [ebp - local_40a0], edx        # 00447a41
    jmp.d32 L_00447956                           # 00447a47
L_00447a4c:
    # block 0x00447a4c: entered by jge at 0x0044796a, 10 instruction(s), ends with backward jump to 0x0044792c
    mov eax, dword ptr [ebp - local_40bc]        # 00447a4c
    mov ecx, dword ptr [eax + field_3d]          # 00447a52
    sub ecx, dword ptr [ebp - local_4088]        # 00447a55
    mov edx, dword ptr [ebp - local_40a0]        # 00447a5b
    {load} add edx, ecx                          # 00447a61
    mov dword ptr [ebp - local_40a0], edx        # 00447a63
    mov eax, dword ptr [ebp - local_4]           # 00447a69
    add eax, dword ptr [ebp - local_4090]        # 00447a6c
    mov dword ptr [ebp - local_4], eax           # 00447a72
    jmp.d32 L_0044792c                           # 00447a75
L_00447a7a:
    # block 0x00447a7a: entered by jge at 0x00447947, 11 instruction(s), calls FUN_004c4202, ends with jne to 0x00447ab6 (forward)
    push 0x548578                                # 00447a7a
    mov ecx, dword ptr [ebp - local_40bc]        # 00447a7f
    add ecx, 0x1d                                # 00447a85
    push ecx                                     # 00447a88
    mov edx, dword ptr [ebp + arg_8]             # 00447a89
    push edx                                     # 00447a8c
    mov ecx, 0x5cf659                            # 00447a8d
    call FUN_004c4202                            # 00447a92
    mov eax, dword ptr [ebp + arg_8]             # 00447a97
    cmp eax, dword ptr [0x5cf665]                # 00447a9a
    jne.d8 L_00447ab6                            # 00447aa0
    # block 0x00447aa2: entered by fall-through of jne at 0x00447aa0, 5 instruction(s), calls FUN_004c952f, falls into the block at 0x00447ab6
    mov ecx, dword ptr [ebp - local_40bc]        # 00447aa2
    add ecx, 0x1d                                # 00447aa8
    push ecx                                     # 00447aab
    mov ecx, 0x5cf659                            # 00447aac
    call FUN_004c952f                            # 00447ab1
L_00447ab6:
    # block 0x00447ab6: entered by jne at 0x00447aa0, 6 instruction(s), calls FUN_004c4c2b, ends with ret 0x14
    mov ecx, 0x5cf659                            # 00447ab6
    call FUN_004c4c2b                            # 00447abb
    pop esi                                      # 00447ac0
    {load} mov esp, ebp                          # 00447ac1
    pop ebp                                      # 00447ac3
    ret 0x14                                     # 00447ac4

