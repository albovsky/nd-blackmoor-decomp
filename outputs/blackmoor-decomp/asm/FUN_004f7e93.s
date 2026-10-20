# FUN_004f7e93
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f7e93
# extent:       0x004f7e93-0x004f80d3 (576 code bytes)
# span:         0x004f7e93-0x004f80d3 (code 576, tables 0, padding 0)
# sha256:       6dd119aae0ea926a8458e6aed739cb51ac091a2f1ce63039c52d6cc6f69ef708
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_direct_sound_update_3d_sound
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4f7e93.c.txt, not original source) refers to the data labelled s_CDirectSound__Update3DSound_____c_0055ed4c
# name-note:    Updates a channel 3D position, min and max distance when given values are not the 10000 sentinel; logs CDirectSound::Update3DSound.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_2, field_e, field_12, field_162, field_28b, field_2a7, field_2ab, field_3c2, field_3ce; [ecx + n] field_6, field_a, field_12, field_12c, field_28f, field_2a3, field_2a7; [edx + n] field_6, field_a, field_e, field_29b, field_2a3, field_2ab
# callees:      calls FUN_004f709c, FUN_004f8f94, FUN_004f9040, FUN_0050ca3e, FUN_0044a2b7, FUN_004f9234, FUN_004f93ec
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 159 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_2, 0x2  # offset +0x2
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_e, 0xe  # offset +0xe
.equ field_12, 0x12  # offset +0x12
.equ field_12c, 0x12c  # offset +0x12c
.equ field_162, 0x162  # offset +0x162
.equ field_28b, 0x28b  # offset +0x28b
.equ field_28f, 0x28f  # offset +0x28f
.equ field_29b, 0x29b  # offset +0x29b
.equ field_2a3, 0x2a3  # offset +0x2a3
.equ field_2a7, 0x2a7  # offset +0x2a7
.equ field_2ab, 0x2ab  # offset +0x2ab
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f709c, .text + (0x004f709c - 0x401000)
.set FUN_004f8f94, .text + (0x004f8f94 - 0x401000)
.set FUN_004f9040, .text + (0x004f9040 - 0x401000)
.set FUN_004f9234, .text + (0x004f9234 - 0x401000)
.set FUN_004f93ec, .text + (0x004f93ec - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f7e93 - 0x401000
.globl FUN_004f7e93
FUN_004f7e93:
    # block 0x004f7e93: entry, 20 instruction(s), calls FUN_004f709c, ends with jne to 0x004f7ee0 (forward)
    push ebp                                     # 004f7e93
    {load} mov ebp, esp                          # 004f7e94
    sub esp, 0x14                                # 004f7e96
    mov dword ptr [ebp - local_c], ecx           # 004f7e99
    mov eax, dword ptr [ebp - local_c]           # 004f7e9c
    mov dword ptr [eax + field_3c2], 0x3e8       # 004f7e9f
    mov ecx, dword ptr [ebp + arg_8]             # 004f7ea9
    movsx edx, word ptr [ecx]                    # 004f7eac
    imul edx, edx, 0x5bb                         # 004f7eaf
    mov eax, dword ptr [ebp - local_c]           # 004f7eb5
    mov ecx, dword ptr [eax + field_3ce]         # 004f7eb8
    {load} add ecx, edx                          # 004f7ebe
    mov dword ptr [ebp - local_8], ecx           # 004f7ec0
    mov edx, dword ptr [ebp - local_8]           # 004f7ec3
    add edx, 0x19e                               # 004f7ec6
    mov dword ptr [ebp - local_4], edx           # 004f7ecc
    mov ecx, dword ptr [ebp - local_c]           # 004f7ecf
    call FUN_004f709c                            # 004f7ed2
    test eax, eax                                # 004f7ed7
    jne.d8 L_004f7ee0                            # 004f7ed9
    # block 0x004f7edb: entered by fall-through of jne at 0x004f7ed9, 1 instruction(s), ends with forward jump to 0x004f80cd
    jmp.d32 L_004f80cd                           # 004f7edb
L_004f7ee0:
    # block 0x004f7ee0: entered by jne at 0x004f7ed9, 3 instruction(s), ends with je to 0x004f7f10 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f7ee0
    cmp dword ptr [eax + field_162], 0x0         # 004f7ee3
    je.d8 L_004f7f10                             # 004f7eea
    # block 0x004f7eec: entered by fall-through of je at 0x004f7eea, 3 instruction(s), ends with je to 0x004f7f10 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004f7eec
    cmp dword ptr [ecx + field_28f], 0x0         # 004f7eef
    je.d8 L_004f7f10                             # 004f7ef6
    # block 0x004f7ef8: entered by fall-through of je at 0x004f7ef6, 3 instruction(s), ends with je to 0x004f7f10 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f7ef8
    cmp dword ptr [edx + field_29b], 0x0         # 004f7efb
    je.d8 L_004f7f10                             # 004f7f02
    # block 0x004f7f04: entered by fall-through of je at 0x004f7f02, 3 instruction(s), ends with jne to 0x004f7f15 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f7f04
    cmp dword ptr [eax + field_28b], 0x0         # 004f7f07
    jne.d8 L_004f7f15                            # 004f7f0e
L_004f7f10:
    # block 0x004f7f10: entered by je at 0x004f7eea; je at 0x004f7ef6; je at 0x004f7f02; fall-through of jne at 0x004f7f0e, 1 instruction(s), ends with forward jump to 0x004f80cd
    jmp.d32 L_004f80cd                           # 004f7f10
L_004f7f15:
    # block 0x004f7f15: entered by jne at 0x004f7f0e, 5 instruction(s), ends with jne to 0x004f800d (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004f7f15
    {load} xor edx, edx                          # 004f7f18
    mov dx, word ptr [ecx + field_12c]           # 004f7f1a
    cmp edx, 0x3                                 # 004f7f21
    jne.d32 L_004f800d                           # 004f7f24
    # block 0x004f7f2a: entered by fall-through of jne at 0x004f7f24, 3 instruction(s), ends with je to 0x004f800d (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004f7f2a
    cmp dword ptr [eax + field_2], 0x2710        # 004f7f2d
    je.d32 L_004f800d                            # 004f7f34
    # block 0x004f7f3a: entered by fall-through of je at 0x004f7f34, 3 instruction(s), ends with je to 0x004f800d (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004f7f3a
    cmp dword ptr [ecx + field_6], 0x2710        # 004f7f3d
    je.d32 L_004f800d                            # 004f7f44
    # block 0x004f7f4a: entered by fall-through of je at 0x004f7f44, 3 instruction(s), ends with je to 0x004f800d (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004f7f4a
    cmp dword ptr [edx + field_a], 0x2710        # 004f7f4d
    je.d32 L_004f800d                            # 004f7f54
    # block 0x004f7f5a: entered by fall-through of je at 0x004f7f54, 28 instruction(s), calls FUN_004f8f94, FUN_004f9040, ends with je to 0x004f800d (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004f7f5a
    fild dword ptr [eax + field_2]               # 004f7f5d
    mov ecx, dword ptr [ebp - local_8]           # 004f7f60
    fstp dword ptr [ecx + field_2a3]             # 004f7f63
    mov edx, dword ptr [ebp + arg_8]             # 004f7f69
    fild dword ptr [edx + field_6]               # 004f7f6c
    mov eax, dword ptr [ebp - local_8]           # 004f7f6f
    fstp dword ptr [eax + field_2a7]             # 004f7f72
    mov ecx, dword ptr [ebp + arg_8]             # 004f7f78
    fild dword ptr [ecx + field_a]               # 004f7f7b
    mov edx, dword ptr [ebp - local_8]           # 004f7f7e
    fstp dword ptr [edx + field_2ab]             # 004f7f81
    mov eax, dword ptr [ebp + arg_8]             # 004f7f87
    movsx ecx, word ptr [eax]                    # 004f7f8a
    push ecx                                     # 004f7f8d
    mov ecx, dword ptr [ebp - local_c]           # 004f7f8e
    call FUN_004f8f94                            # 004f7f91
    mov edx, dword ptr [ebp - local_8]           # 004f7f96
    add edx, 0x2a3                               # 004f7f99
    push edx                                     # 004f7f9f
    mov eax, dword ptr [ebp + arg_8]             # 004f7fa0
    movsx ecx, word ptr [eax]                    # 004f7fa3
    push ecx                                     # 004f7fa6
    mov ecx, dword ptr [ebp - local_c]           # 004f7fa7
    call FUN_004f9040                            # 004f7faa
    movsx edx, word ptr [0x63a4cd]               # 004f7faf
    test edx, edx                                # 004f7fb6
    je.d8 L_004f800d                             # 004f7fb8
    # block 0x004f7fba: entered by fall-through of je at 0x004f7fb8, 22 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f800d
    mov eax, dword ptr [ebp - local_8]           # 004f7fba
    fld dword ptr [eax + field_2ab]              # 004f7fbd
    sub esp, 0x8                                 # 004f7fc3
    fstp qword ptr [esp]                         # 004f7fc6
    mov ecx, dword ptr [ebp - local_8]           # 004f7fc9
    fld dword ptr [ecx + field_2a7]              # 004f7fcc
    sub esp, 0x8                                 # 004f7fd2
    fstp qword ptr [esp]                         # 004f7fd5
    mov edx, dword ptr [ebp - local_8]           # 004f7fd8
    fld dword ptr [edx + field_2a3]              # 004f7fdb
    sub esp, 0x8                                 # 004f7fe1
    fstp qword ptr [esp]                         # 004f7fe4
    mov eax, dword ptr [ebp + arg_8]             # 004f7fe7
    movsx ecx, word ptr [eax]                    # 004f7fea
    push ecx                                     # 004f7fed
    push 0x55ed4c                                # 004f7fee
    push 0x63888b                                # 004f7ff3
    call FUN_0050ca3e                            # 004f7ff8
    add esp, 0x24                                # 004f7ffd
    push 0x63888b                                # 004f8000
    call FUN_0044a2b7                            # 004f8005
    add esp, 0x4                                 # 004f800a
L_004f800d:
    # block 0x004f800d: entered by jne at 0x004f7f24; je at 0x004f7f34; je at 0x004f7f44; je at 0x004f7f54; je at 0x004f7fb8, 3 instruction(s), ends with je to 0x004f806d (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004f800d
    cmp dword ptr [edx + field_e], 0x2710        # 004f8010
    je.d8 L_004f806d                             # 004f8017
    # block 0x004f8019: entered by fall-through of je at 0x004f8017, 13 instruction(s), calls FUN_004f9234, ends with je to 0x004f806d (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004f8019
    fild dword ptr [eax + field_e]               # 004f801c
    fstp dword ptr [ebp - local_10]              # 004f801f
    mov ecx, dword ptr [ebp - local_10]          # 004f8022
    push ecx                                     # 004f8025
    mov edx, dword ptr [ebp + arg_8]             # 004f8026
    movsx eax, word ptr [edx]                    # 004f8029
    push eax                                     # 004f802c
    mov ecx, dword ptr [ebp - local_c]           # 004f802d
    call FUN_004f9234                            # 004f8030
    movsx ecx, word ptr [0x63a4cd]               # 004f8035
    test ecx, ecx                                # 004f803c
    je.d8 L_004f806d                             # 004f803e
    # block 0x004f8040: entered by fall-through of je at 0x004f803e, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f806d
    mov edx, dword ptr [ebp + arg_8]             # 004f8040
    mov eax, dword ptr [edx + field_e]           # 004f8043
    push eax                                     # 004f8046
    mov ecx, dword ptr [ebp + arg_8]             # 004f8047
    movsx edx, word ptr [ecx]                    # 004f804a
    push edx                                     # 004f804d
    push 0x55ed9c                                # 004f804e
    push 0x63888b                                # 004f8053
    call FUN_0050ca3e                            # 004f8058
    add esp, 0x10                                # 004f805d
    push 0x63888b                                # 004f8060
    call FUN_0044a2b7                            # 004f8065
    add esp, 0x4                                 # 004f806a
L_004f806d:
    # block 0x004f806d: entered by je at 0x004f8017; je at 0x004f803e, 3 instruction(s), ends with je to 0x004f80cd (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004f806d
    cmp dword ptr [eax + field_12], 0x2710       # 004f8070
    je.d8 L_004f80cd                             # 004f8077
    # block 0x004f8079: entered by fall-through of je at 0x004f8077, 13 instruction(s), calls FUN_004f93ec, ends with je to 0x004f80cd (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004f8079
    fild dword ptr [ecx + field_12]              # 004f807c
    fstp dword ptr [ebp - local_14]              # 004f807f
    mov edx, dword ptr [ebp - local_14]          # 004f8082
    push edx                                     # 004f8085
    mov eax, dword ptr [ebp + arg_8]             # 004f8086
    movsx ecx, word ptr [eax]                    # 004f8089
    push ecx                                     # 004f808c
    mov ecx, dword ptr [ebp - local_c]           # 004f808d
    call FUN_004f93ec                            # 004f8090
    movsx edx, word ptr [0x63a4cd]               # 004f8095
    test edx, edx                                # 004f809c
    je.d8 L_004f80cd                             # 004f809e
    # block 0x004f80a0: entered by fall-through of je at 0x004f809e, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f80cd
    mov eax, dword ptr [ebp + arg_8]             # 004f80a0
    mov ecx, dword ptr [eax + field_12]          # 004f80a3
    push ecx                                     # 004f80a6
    mov edx, dword ptr [ebp + arg_8]             # 004f80a7
    movsx eax, word ptr [edx]                    # 004f80aa
    push eax                                     # 004f80ad
    push 0x55ede4                                # 004f80ae
    push 0x63888b                                # 004f80b3
    call FUN_0050ca3e                            # 004f80b8
    add esp, 0x10                                # 004f80bd
    push 0x63888b                                # 004f80c0
    call FUN_0044a2b7                            # 004f80c5
    add esp, 0x4                                 # 004f80ca
L_004f80cd:
    # block 0x004f80cd: entered by jmp at 0x004f7edb; jmp at 0x004f7f10; je at 0x004f8077; je at 0x004f809e, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004f80cd
    pop ebp                                      # 004f80cf
    ret 0x4                                      # 004f80d0

