# FUN_004f3c26
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f3c26
# extent:       0x004f3c26-0x004f438f (1897 code bytes)
# span:         0x004f3c26-0x004f438f (code 1897, tables 0, padding 0)
# sha256:       a1a739d50af19d3bcd0c42b12b921b344ee44fbfa8e8dfe250e636dcfe606ff5
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_his_in_memory_sound_path
# naming:       INFERRED (lower confidence, not verified): the repository text his-audio-recovery.md:14 says "It chooses the in-memory path at `0x4f3c26` for decoded sizes below `0x56221`"; src/live_audio.c:42 says "(0x4f3c26, stream_state 0)"
# name-note:    In-memory load path for decoded sizes below 0x56221 (stream_state 0).
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_144, field_156, field_15e, field_28f, field_293, field_297, field_29b, field_2ab and 3 more; [ecx + n] field_4, field_8, field_c, field_116, field_122, field_126, field_156, field_15e, field_28f, field_293, field_297, field_29b and 8 more; [edx + n] field_4, field_8, field_c, field_10, field_156, field_28f, field_297, field_29f, field_2a3, field_2b3, field_2be, field_2d3 and 4 more
# callees:      calls FUN_004f5f69, FUN_004f356e, FUN_0050ca3e, FUN_0044a2b7, FUN_004f95a4, FUN_0051dc43, FUN_004fdb90, FUN_0052139c, FUN_004f594d, FUN_004fcef0, FUN_0050cee4, FUN_004f684a; plus 5 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36a.c:m4f379c_open_entry (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 482 instruction(s), 17 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_116, 0x116  # offset +0x116
.equ field_122, 0x122  # offset +0x122
.equ field_126, 0x126  # offset +0x126
.equ field_144, 0x144  # offset +0x144
.equ field_156, 0x156  # offset +0x156
.equ field_15e, 0x15e  # offset +0x15e
.equ field_28f, 0x28f  # offset +0x28f
.equ field_293, 0x293  # offset +0x293
.equ field_297, 0x297  # offset +0x297
.equ field_29b, 0x29b  # offset +0x29b
.equ field_29f, 0x29f  # offset +0x29f
.equ field_2a3, 0x2a3  # offset +0x2a3
.equ field_2a7, 0x2a7  # offset +0x2a7
.equ field_2ab, 0x2ab  # offset +0x2ab
.equ field_2af, 0x2af  # offset +0x2af
.equ field_2b3, 0x2b3  # offset +0x2b3
.equ field_2b7, 0x2b7  # offset +0x2b7
.equ field_2be, 0x2be  # offset +0x2be
.equ field_2d3, 0x2d3  # offset +0x2d3
.equ field_2d7, 0x2d7  # offset +0x2d7
.equ field_2db, 0x2db  # offset +0x2db
.equ field_2f1, 0x2f1  # offset +0x2f1
.equ field_3be, 0x3be  # offset +0x3be
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f356e, .text + (0x004f356e - 0x401000)
.set FUN_004f594d, .text + (0x004f594d - 0x401000)
.set FUN_004f5f69, .text + (0x004f5f69 - 0x401000)
.set FUN_004f684a, .text + (0x004f684a - 0x401000)
.set FUN_004f95a4, .text + (0x004f95a4 - 0x401000)
.set FUN_004fcef0, .text + (0x004fcef0 - 0x401000)
.set FUN_004fdb90, .text + (0x004fdb90 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004f3c26 - 0x401000
.globl FUN_004f3c26
FUN_004f3c26:
    # block 0x004f3c26: entry, 43 instruction(s), ends with je to 0x004f3d0d (forward)
    push ebp                                     # 004f3c26
    {load} mov ebp, esp                          # 004f3c27
    sub esp, 0x14                                # 004f3c29
    push edi                                     # 004f3c2c
    mov dword ptr [ebp - local_14], ecx          # 004f3c2d
    mov eax, dword ptr [ebp - local_14]          # 004f3c30
    mov dword ptr [eax + field_3be], 0x1         # 004f3c33
    mov ecx, dword ptr [ebp - local_14]          # 004f3c3d
    mov dword ptr [ecx + field_3c2], 0x3e8       # 004f3c40
    mov edx, dword ptr [ebp - local_14]          # 004f3c4a
    mov dword ptr [edx + field_3ca], 0x0         # 004f3c4d
    mov eax, dword ptr [ebp + arg_8]             # 004f3c57
    and eax, 0xffff                              # 004f3c5a
    imul eax, eax, 0x5bb                         # 004f3c5f
    mov ecx, dword ptr [ebp - local_14]          # 004f3c65
    mov edx, dword ptr [ecx + field_3ce]         # 004f3c68
    {load} add edx, eax                          # 004f3c6e
    mov dword ptr [ebp - local_8], edx           # 004f3c70
    mov eax, dword ptr [ebp - local_8]           # 004f3c73
    add eax, 0x18a                               # 004f3c76
    mov dword ptr [ebp - local_4], eax           # 004f3c7b
    mov dword ptr [ebp - local_c], 0x0           # 004f3c7e
    mov ecx, dword ptr [ebp - local_4]           # 004f3c85
    mov dword ptr [ecx], 0x0                     # 004f3c88
    mov edx, dword ptr [ebp - local_4]           # 004f3c8e
    mov dword ptr [edx + field_4], 0x0           # 004f3c91
    mov eax, dword ptr [ebp - local_4]           # 004f3c98
    mov dword ptr [eax + field_8], 0x0           # 004f3c9b
    mov ecx, dword ptr [ebp - local_4]           # 004f3ca2
    mov dword ptr [ecx + field_c], 0x0           # 004f3ca5
    mov edx, dword ptr [ebp - local_4]           # 004f3cac
    mov dword ptr [edx + field_10], 0x0          # 004f3caf
    mov eax, dword ptr [ebp - local_8]           # 004f3cb6
    mov ecx, dword ptr [ebp - local_8]           # 004f3cb9
    mov dx, word ptr [ecx + field_116]           # 004f3cbc
    mov word ptr [eax + field_144], dx           # 004f3cc3
    mov eax, dword ptr [ebp - local_8]           # 004f3cca
    mov ecx, dword ptr [ebp - local_8]           # 004f3ccd
    mov edx, dword ptr [ecx + field_122]         # 004f3cd0
    mov dword ptr [eax + field_15e], edx         # 004f3cd6
    mov eax, dword ptr [ebp - local_8]           # 004f3cdc
    cmp dword ptr [eax + field_293], 0x0         # 004f3cdf
    je.d8 L_004f3d0d                             # 004f3ce6
    # block 0x004f3ce8: entered by fall-through of je at 0x004f3ce6, 9 instruction(s), calls indirect dword ptr [eax + 0x8], falls into the block at 0x004f3d0d
    mov ecx, dword ptr [ebp - local_8]           # 004f3ce8
    mov edx, dword ptr [ecx + field_293]         # 004f3ceb
    mov eax, dword ptr [ebp - local_8]           # 004f3cf1
    mov ecx, dword ptr [eax + field_293]         # 004f3cf4
    mov eax, dword ptr [ecx]                     # 004f3cfa
    push edx                                     # 004f3cfc
    call dword ptr [eax + field_8]               # 004f3cfd
    mov ecx, dword ptr [ebp - local_8]           # 004f3d00
    mov dword ptr [ecx + field_293], 0x0         # 004f3d03
L_004f3d0d:
    # block 0x004f3d0d: entered by je at 0x004f3ce6, 48 instruction(s), calls FUN_004f5f69, ends with jne to 0x004f3df1 (forward)
    {load} xor edx, edx                          # 004f3d0d
    mov eax, dword ptr [ebp - local_14]          # 004f3d0f
    add eax, 0x288                               # 004f3d12
    mov dword ptr [eax], edx                     # 004f3d17
    mov dword ptr [eax + field_4], edx           # 004f3d19
    mov dword ptr [eax + field_8], edx           # 004f3d1c
    mov dword ptr [eax + field_c], edx           # 004f3d1f
    mov word ptr [eax + field_10], dx            # 004f3d22
    mov ecx, dword ptr [ebp - local_8]           # 004f3d26
    add ecx, 0x112                               # 004f3d29
    mov edx, dword ptr [ebp - local_14]          # 004f3d2f
    add edx, 0x288                               # 004f3d32
    mov eax, dword ptr [ecx]                     # 004f3d38
    mov dword ptr [edx], eax                     # 004f3d3a
    mov eax, dword ptr [ecx + field_4]           # 004f3d3c
    mov dword ptr [edx + field_4], eax           # 004f3d3f
    mov eax, dword ptr [ecx + field_8]           # 004f3d42
    mov dword ptr [edx + field_8], eax           # 004f3d45
    mov ecx, dword ptr [ecx + field_c]           # 004f3d48
    mov dword ptr [edx + field_c], ecx           # 004f3d4b
    mov edx, dword ptr [ebp - local_14]          # 004f3d4e
    add edx, 0x288                               # 004f3d51
    mov eax, dword ptr [ebp - local_8]           # 004f3d57
    add eax, 0x2df                               # 004f3d5a
    mov ecx, dword ptr [edx]                     # 004f3d5f
    mov dword ptr [eax], ecx                     # 004f3d61
    mov ecx, dword ptr [edx + field_4]           # 004f3d63
    mov dword ptr [eax + field_4], ecx           # 004f3d66
    mov ecx, dword ptr [edx + field_8]           # 004f3d69
    mov dword ptr [eax + field_8], ecx           # 004f3d6c
    mov ecx, dword ptr [edx + field_c]           # 004f3d6f
    mov dword ptr [eax + field_c], ecx           # 004f3d72
    mov dx, word ptr [edx + field_10]            # 004f3d75
    mov word ptr [eax + field_10], dx            # 004f3d79
    mov eax, dword ptr [ebp - local_14]          # 004f3d7d
    add eax, 0x288                               # 004f3d80
    push eax                                     # 004f3d85
    push 0x301ba                                 # 004f3d86
    mov ecx, dword ptr [ebp - local_8]           # 004f3d8b
    mov edx, dword ptr [ecx + field_15e]         # 004f3d8e
    push edx                                     # 004f3d94
    mov eax, dword ptr [ebp - local_8]           # 004f3d95
    add eax, 0x28f                               # 004f3d98
    push eax                                     # 004f3d9d
    mov ecx, dword ptr [ebp - local_14]          # 004f3d9e
    call FUN_004f5f69                            # 004f3da1
    test eax, eax                                # 004f3da6
    jne.d8 L_004f3df1                            # 004f3da8
    # block 0x004f3daa: entered by fall-through of jne at 0x004f3da8, 14 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f4388
    mov ecx, dword ptr [ebp - local_8]           # 004f3daa
    mov dword ptr [ecx + field_28f], 0x0         # 004f3dad
    mov edx, dword ptr [ebp + arg_8]             # 004f3db7
    and edx, 0xffff                              # 004f3dba
    push edx                                     # 004f3dc0
    mov ecx, dword ptr [ebp - local_14]          # 004f3dc1
    call FUN_004f356e                            # 004f3dc4
    mov eax, dword ptr [ebp - local_14]          # 004f3dc9
    mov dword ptr [eax + field_3c2], 0x404       # 004f3dcc
    mov ecx, dword ptr [ebp - local_14]          # 004f3dd6
    mov dword ptr [ecx + field_3be], 0x0         # 004f3dd9
    mov edx, dword ptr [ebp - local_14]          # 004f3de3
    mov eax, dword ptr [edx + field_3be]         # 004f3de6
    jmp.d32 L_004f4388                           # 004f3dec
L_004f3df1:
    # block 0x004f3df1: entered by jne at 0x004f3da8, 3 instruction(s), ends with je to 0x004f3e36 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f3df1
    test eax, eax                                # 004f3df8
    je.d8 L_004f3e36                             # 004f3dfa
    # block 0x004f3dfc: entered by fall-through of je at 0x004f3dfa, 16 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f3e36
    mov ecx, dword ptr [ebp - local_8]           # 004f3dfc
    add ecx, 0x4                                 # 004f3dff
    push ecx                                     # 004f3e02
    mov edx, dword ptr [ebp + arg_8]             # 004f3e03
    and edx, 0xffff                              # 004f3e06
    push edx                                     # 004f3e0c
    mov eax, dword ptr [ebp - local_8]           # 004f3e0d
    mov ecx, dword ptr [eax + field_15e]         # 004f3e10
    push ecx                                     # 004f3e16
    push 0x55db74                                # 004f3e17
    push 0x63888b                                # 004f3e1c
    call FUN_0050ca3e                            # 004f3e21
    add esp, 0x14                                # 004f3e26
    push 0x63888b                                # 004f3e29
    call FUN_0044a2b7                            # 004f3e2e
    add esp, 0x4                                 # 004f3e33
L_004f3e36:
    # block 0x004f3e36: entered by je at 0x004f3dfa, 16 instruction(s), calls indirect dword ptr [edx], ends with je to 0x004f3eb8 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f3e36
    add edx, 0x29b                               # 004f3e39
    push edx                                     # 004f3e3f
    push 0x52e53c                                # 004f3e40
    mov eax, dword ptr [ebp - local_8]           # 004f3e45
    mov ecx, dword ptr [eax + field_28f]         # 004f3e48
    mov edx, dword ptr [ebp - local_8]           # 004f3e4e
    mov eax, dword ptr [edx + field_28f]         # 004f3e51
    mov edx, dword ptr [eax]                     # 004f3e57
    push ecx                                     # 004f3e59
    call dword ptr [edx]                         # 004f3e5a
    mov ecx, dword ptr [ebp - local_14]          # 004f3e5c
    mov dword ptr [ecx + field_3ca], eax         # 004f3e5f
    mov edx, dword ptr [ebp - local_14]          # 004f3e65
    cmp dword ptr [edx + field_3ca], 0x0         # 004f3e68
    je.d8 L_004f3eb8                             # 004f3e6f
    # block 0x004f3e71: entered by fall-through of je at 0x004f3e6f, 14 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f4388
    mov eax, dword ptr [ebp - local_8]           # 004f3e71
    mov dword ptr [eax + field_29b], 0x0         # 004f3e74
    mov ecx, dword ptr [ebp + arg_8]             # 004f3e7e
    and ecx, 0xffff                              # 004f3e81
    push ecx                                     # 004f3e87
    mov ecx, dword ptr [ebp - local_14]          # 004f3e88
    call FUN_004f356e                            # 004f3e8b
    mov edx, dword ptr [ebp - local_14]          # 004f3e90
    mov dword ptr [edx + field_3c2], 0x417       # 004f3e93
    mov eax, dword ptr [ebp - local_14]          # 004f3e9d
    mov dword ptr [eax + field_3be], 0x0         # 004f3ea0
    mov ecx, dword ptr [ebp - local_14]          # 004f3eaa
    mov eax, dword ptr [ecx + field_3be]         # 004f3ead
    jmp.d32 L_004f4388                           # 004f3eb3
L_004f3eb8:
    # block 0x004f3eb8: entered by je at 0x004f3e6f, 3 instruction(s), ends with je to 0x004f3ef3 (forward)
    movsx edx, word ptr [0x63a4cd]               # 004f3eb8
    test edx, edx                                # 004f3ebf
    je.d8 L_004f3ef3                             # 004f3ec1
    # block 0x004f3ec3: entered by fall-through of je at 0x004f3ec1, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f3ef3
    mov eax, dword ptr [ebp - local_8]           # 004f3ec3
    add eax, 0x4                                 # 004f3ec6
    push eax                                     # 004f3ec9
    mov ecx, dword ptr [ebp + arg_8]             # 004f3eca
    and ecx, 0xffff                              # 004f3ecd
    push ecx                                     # 004f3ed3
    push 0x55dbc8                                # 004f3ed4
    push 0x63888b                                # 004f3ed9
    call FUN_0050ca3e                            # 004f3ede
    add esp, 0x10                                # 004f3ee3
    push 0x63888b                                # 004f3ee6
    call FUN_0044a2b7                            # 004f3eeb
    add esp, 0x4                                 # 004f3ef0
L_004f3ef3:
    # block 0x004f3ef3: entered by je at 0x004f3ec1, 22 instruction(s), calls indirect dword ptr [eax + 0xc], ends with je to 0x004f3f81 (forward)
    mov ecx, 0x10                                # 004f3ef3
    {load} xor eax, eax                          # 004f3ef8
    mov edi, dword ptr [ebp - local_8]           # 004f3efa
    add edi, 0x29f                               # 004f3efd
    rep stosd dword ptr es:[edi], eax            # 004f3f03
    mov edx, dword ptr [ebp - local_8]           # 004f3f05
    mov dword ptr [edx + field_29f], 0x40        # 004f3f08
    mov eax, dword ptr [ebp - local_8]           # 004f3f12
    add eax, 0x29f                               # 004f3f15
    push eax                                     # 004f3f1a
    mov ecx, dword ptr [ebp - local_8]           # 004f3f1b
    mov edx, dword ptr [ecx + field_29b]         # 004f3f1e
    mov eax, dword ptr [ebp - local_8]           # 004f3f24
    mov ecx, dword ptr [eax + field_29b]         # 004f3f27
    mov eax, dword ptr [ecx]                     # 004f3f2d
    push edx                                     # 004f3f2f
    call dword ptr [eax + field_c]               # 004f3f30
    mov ecx, dword ptr [ebp - local_14]          # 004f3f33
    mov dword ptr [ecx + field_3ca], eax         # 004f3f36
    mov edx, dword ptr [ebp - local_14]          # 004f3f3c
    cmp dword ptr [edx + field_3ca], 0x0         # 004f3f3f
    je.d8 L_004f3f81                             # 004f3f46
    # block 0x004f3f48: entered by fall-through of je at 0x004f3f46, 12 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f4388
    mov eax, dword ptr [ebp + arg_8]             # 004f3f48
    and eax, 0xffff                              # 004f3f4b
    push eax                                     # 004f3f50
    mov ecx, dword ptr [ebp - local_14]          # 004f3f51
    call FUN_004f356e                            # 004f3f54
    mov ecx, dword ptr [ebp - local_14]          # 004f3f59
    mov dword ptr [ecx + field_3c2], 0x418       # 004f3f5c
    mov edx, dword ptr [ebp - local_14]          # 004f3f66
    mov dword ptr [edx + field_3be], 0x0         # 004f3f69
    mov eax, dword ptr [ebp - local_14]          # 004f3f73
    mov eax, dword ptr [eax + field_3be]         # 004f3f76
    jmp.d32 L_004f4388                           # 004f3f7c
L_004f3f81:
    # block 0x004f3f81: entered by je at 0x004f3f46, 8 instruction(s), calls FUN_004f95a4, ends with je to 0x004f409d (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004f3f81
    and ecx, 0xffff                              # 004f3f84
    push ecx                                     # 004f3f8a
    mov ecx, dword ptr [ebp - local_14]          # 004f3f8b
    call FUN_004f95a4                            # 004f3f8e
    movsx edx, word ptr [0x63a4cd]               # 004f3f93
    test edx, edx                                # 004f3f9a
    je.d32 L_004f409d                            # 004f3f9c
    # block 0x004f3fa2: entered by fall-through of je at 0x004f3f9c, 65 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f409d
    mov eax, dword ptr [ebp - local_8]           # 004f3fa2
    fld dword ptr [eax + field_2ab]              # 004f3fa5
    sub esp, 0x8                                 # 004f3fab
    fstp qword ptr [esp]                         # 004f3fae
    mov ecx, dword ptr [ebp - local_8]           # 004f3fb1
    fld dword ptr [ecx + field_2a7]              # 004f3fb4
    sub esp, 0x8                                 # 004f3fba
    fstp qword ptr [esp]                         # 004f3fbd
    mov edx, dword ptr [ebp - local_8]           # 004f3fc0
    fld dword ptr [edx + field_2a3]              # 004f3fc3
    sub esp, 0x8                                 # 004f3fc9
    fstp qword ptr [esp]                         # 004f3fcc
    mov eax, dword ptr [ebp + arg_8]             # 004f3fcf
    and eax, 0xffff                              # 004f3fd2
    push eax                                     # 004f3fd7
    push 0x55dc14                                # 004f3fd8
    push 0x63888b                                # 004f3fdd
    call FUN_0050ca3e                            # 004f3fe2
    add esp, 0x24                                # 004f3fe7
    push 0x63888b                                # 004f3fea
    call FUN_0044a2b7                            # 004f3fef
    add esp, 0x4                                 # 004f3ff4
    mov ecx, dword ptr [ebp - local_8]           # 004f3ff7
    fld dword ptr [ecx + field_2b7]              # 004f3ffa
    sub esp, 0x8                                 # 004f4000
    fstp qword ptr [esp]                         # 004f4003
    mov edx, dword ptr [ebp - local_8]           # 004f4006
    fld dword ptr [edx + field_2b3]              # 004f4009
    sub esp, 0x8                                 # 004f400f
    fstp qword ptr [esp]                         # 004f4012
    mov eax, dword ptr [ebp - local_8]           # 004f4015
    fld dword ptr [eax + field_2af]              # 004f4018
    sub esp, 0x8                                 # 004f401e
    fstp qword ptr [esp]                         # 004f4021
    mov ecx, dword ptr [ebp + arg_8]             # 004f4024
    and ecx, 0xffff                              # 004f4027
    push ecx                                     # 004f402d
    push 0x55dc7c                                # 004f402e
    push 0x63888b                                # 004f4033
    call FUN_0050ca3e                            # 004f4038
    add esp, 0x24                                # 004f403d
    push 0x63888b                                # 004f4040
    call FUN_0044a2b7                            # 004f4045
    add esp, 0x4                                 # 004f404a
    mov edx, dword ptr [ebp - local_8]           # 004f404d
    mov eax, dword ptr [edx + field_2db]         # 004f4050
    push eax                                     # 004f4056
    mov ecx, dword ptr [ebp - local_8]           # 004f4057
    fld dword ptr [ecx + field_2d7]              # 004f405a
    sub esp, 0x8                                 # 004f4060
    fstp qword ptr [esp]                         # 004f4063
    mov edx, dword ptr [ebp - local_8]           # 004f4066
    fld dword ptr [edx + field_2d3]              # 004f4069
    sub esp, 0x8                                 # 004f406f
    fstp qword ptr [esp]                         # 004f4072
    mov eax, dword ptr [ebp + arg_8]             # 004f4075
    and eax, 0xffff                              # 004f4078
    push eax                                     # 004f407d
    push 0x55dce4                                # 004f407e
    push 0x63888b                                # 004f4083
    call FUN_0050ca3e                            # 004f4088
    add esp, 0x20                                # 004f408d
    push 0x63888b                                # 004f4090
    call FUN_0044a2b7                            # 004f4095
    add esp, 0x4                                 # 004f409a
L_004f409d:
    # block 0x004f409d: entered by je at 0x004f3f9c, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x004f4103 (forward)
    push 0x8                                     # 004f409d
    call FUN_0051dc43                            # 004f409f
    add esp, 0x4                                 # 004f40a4
    mov dword ptr [ebp - local_10], eax          # 004f40a7
    mov ecx, dword ptr [ebp - local_8]           # 004f40aa
    mov edx, dword ptr [ebp - local_10]          # 004f40ad
    mov dword ptr [ecx + field_297], edx         # 004f40b0
    cmp dword ptr [ebp - local_10], 0x0          # 004f40b6
    jne.d8 L_004f4103                            # 004f40ba
    # block 0x004f40bc: entered by fall-through of jne at 0x004f40ba, 14 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f4388
    mov eax, dword ptr [ebp - local_8]           # 004f40bc
    mov dword ptr [eax + field_297], 0x0         # 004f40bf
    mov ecx, dword ptr [ebp + arg_8]             # 004f40c9
    and ecx, 0xffff                              # 004f40cc
    push ecx                                     # 004f40d2
    mov ecx, dword ptr [ebp - local_14]          # 004f40d3
    call FUN_004f356e                            # 004f40d6
    mov edx, dword ptr [ebp - local_14]          # 004f40db
    mov dword ptr [edx + field_3c2], 0x3ee       # 004f40de
    mov eax, dword ptr [ebp - local_14]          # 004f40e8
    mov dword ptr [eax + field_3be], 0x0         # 004f40eb
    mov ecx, dword ptr [ebp - local_14]          # 004f40f5
    mov eax, dword ptr [ecx + field_3be]         # 004f40f8
    jmp.d32 L_004f4388                           # 004f40fe
L_004f4103:
    # block 0x004f4103: entered by jne at 0x004f40ba, 27 instruction(s), calls indirect dword ptr [edx], ends with je to 0x004f41b5 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f4103
    mov eax, dword ptr [edx + field_297]         # 004f4106
    mov dword ptr [eax], 0xffffffff              # 004f410c
    mov ecx, dword ptr [ebp + arg_8]             # 004f4112
    and ecx, 0xffff                              # 004f4115
    shl ecx                                      # 004f411b
    mov edx, dword ptr [ebp - local_8]           # 004f411d
    mov eax, dword ptr [edx + field_297]         # 004f4120
    mov edx, dword ptr [ebp - local_14]          # 004f4126
    mov ecx, dword ptr [edx + 4*ecx + field_2be] # 004f4129
    mov dword ptr [eax + field_4], ecx           # 004f4130
    mov edx, dword ptr [ebp - local_8]           # 004f4133
    add edx, 0x293                               # 004f4136
    push edx                                     # 004f413c
    push 0x52e52c                                # 004f413d
    mov eax, dword ptr [ebp - local_8]           # 004f4142
    mov ecx, dword ptr [eax + field_28f]         # 004f4145
    mov edx, dword ptr [ebp - local_8]           # 004f414b
    mov eax, dword ptr [edx + field_28f]         # 004f414e
    mov edx, dword ptr [eax]                     # 004f4154
    push ecx                                     # 004f4156
    call dword ptr [edx]                         # 004f4157
    mov ecx, dword ptr [ebp - local_14]          # 004f4159
    mov dword ptr [ecx + field_3ca], eax         # 004f415c
    mov edx, dword ptr [ebp - local_14]          # 004f4162
    cmp dword ptr [edx + field_3ca], 0x0         # 004f4165
    je.d8 L_004f41b5                             # 004f416c
    # block 0x004f416e: entered by fall-through of je at 0x004f416c, 14 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f4388
    mov eax, dword ptr [ebp - local_8]           # 004f416e
    mov dword ptr [eax + field_293], 0x0         # 004f4171
    mov ecx, dword ptr [ebp + arg_8]             # 004f417b
    and ecx, 0xffff                              # 004f417e
    push ecx                                     # 004f4184
    mov ecx, dword ptr [ebp - local_14]          # 004f4185
    call FUN_004f356e                            # 004f4188
    mov edx, dword ptr [ebp - local_14]          # 004f418d
    mov dword ptr [edx + field_3c2], 0x412       # 004f4190
    mov eax, dword ptr [ebp - local_14]          # 004f419a
    mov dword ptr [eax + field_3be], 0x0         # 004f419d
    mov ecx, dword ptr [ebp - local_14]          # 004f41a7
    mov eax, dword ptr [ecx + field_3be]         # 004f41aa
    jmp.d32 L_004f4388                           # 004f41b0
L_004f41b5:
    # block 0x004f41b5: entered by je at 0x004f416c, 16 instruction(s), calls indirect dword ptr [eax + 0xc], ends with je to 0x004f4227 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f41b5
    mov eax, dword ptr [edx + field_297]         # 004f41b8
    push eax                                     # 004f41be
    push 0x1                                     # 004f41bf
    mov ecx, dword ptr [ebp - local_8]           # 004f41c1
    mov edx, dword ptr [ecx + field_293]         # 004f41c4
    mov eax, dword ptr [ebp - local_8]           # 004f41ca
    mov ecx, dword ptr [eax + field_293]         # 004f41cd
    mov eax, dword ptr [ecx]                     # 004f41d3
    push edx                                     # 004f41d5
    call dword ptr [eax + field_c]               # 004f41d6
    mov ecx, dword ptr [ebp - local_14]          # 004f41d9
    mov dword ptr [ecx + field_3ca], eax         # 004f41dc
    mov edx, dword ptr [ebp - local_14]          # 004f41e2
    cmp dword ptr [edx + field_3ca], 0x0         # 004f41e5
    je.d8 L_004f4227                             # 004f41ec
    # block 0x004f41ee: entered by fall-through of je at 0x004f41ec, 12 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f4388
    mov eax, dword ptr [ebp + arg_8]             # 004f41ee
    and eax, 0xffff                              # 004f41f1
    push eax                                     # 004f41f6
    mov ecx, dword ptr [ebp - local_14]          # 004f41f7
    call FUN_004f356e                            # 004f41fa
    mov ecx, dword ptr [ebp - local_14]          # 004f41ff
    mov dword ptr [ecx + field_3c2], 0x414       # 004f4202
    mov edx, dword ptr [ebp - local_14]          # 004f420c
    mov dword ptr [edx + field_3be], 0x0         # 004f420f
    mov eax, dword ptr [ebp - local_14]          # 004f4219
    mov eax, dword ptr [eax + field_3be]         # 004f421c
    jmp.d32 L_004f4388                           # 004f4222
L_004f4227:
    # block 0x004f4227: entered by je at 0x004f41ec, 3 instruction(s), ends with je to 0x004f4261 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004f4227
    test ecx, ecx                                # 004f422e
    je.d8 L_004f4261                             # 004f4230
    # block 0x004f4232: entered by fall-through of je at 0x004f4230, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f4261
    mov edx, dword ptr [ebp - local_8]           # 004f4232
    add edx, 0x4                                 # 004f4235
    push edx                                     # 004f4238
    mov eax, dword ptr [ebp + arg_8]             # 004f4239
    and eax, 0xffff                              # 004f423c
    push eax                                     # 004f4241
    push 0x55dd5c                                # 004f4242
    push 0x63888b                                # 004f4247
    call FUN_0050ca3e                            # 004f424c
    add esp, 0x10                                # 004f4251
    push 0x63888b                                # 004f4254
    call FUN_0044a2b7                            # 004f4259
    add esp, 0x4                                 # 004f425e
L_004f4261:
    # block 0x004f4261: entered by je at 0x004f4230, 4 instruction(s), ends with jne to 0x004f42dd (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004f4261
    movsx edx, word ptr [ecx + field_126]        # 004f4264
    cmp edx, 0x2                                 # 004f426b
    jne.d8 L_004f42dd                            # 004f426e
    # block 0x004f4270: entered by fall-through of jne at 0x004f426e, 12 instruction(s), calls FUN_004fdb90, ends with jge to 0x004f42dd (forward)
    push 0x0                                     # 004f4270
    push 0x0                                     # 004f4272
    mov eax, dword ptr [ebp - local_8]           # 004f4274
    add eax, 0x2f1                               # 004f4277
    push eax                                     # 004f427c
    mov ecx, dword ptr [ebp - local_8]           # 004f427d
    mov edx, dword ptr [ecx + field_156]         # 004f4280
    push edx                                     # 004f4286
    call FUN_004fdb90                            # 004f4287
    add esp, 0x10                                # 004f428c
    test eax, eax                                # 004f428f
    jge.d8 L_004f42dd                            # 004f4291
    # block 0x004f4293: entered by fall-through of jge at 0x004f4291, 8 instruction(s), calls FUN_004f356e, ends with je to 0x004f42d6 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004f4293
    and eax, 0xffff                              # 004f4296
    push eax                                     # 004f429b
    mov ecx, dword ptr [ebp - local_14]          # 004f429c
    call FUN_004f356e                            # 004f429f
    movsx ecx, word ptr [0x63a4cd]               # 004f42a4
    test ecx, ecx                                # 004f42ab
    je.d8 L_004f42d6                             # 004f42ad
    # block 0x004f42af: entered by fall-through of je at 0x004f42ad, 11 instruction(s), calls FUN_0050ca3e, FUN_0052139c, falls into the block at 0x004f42d6
    mov edx, dword ptr [ebp - local_8]           # 004f42af
    add edx, 0x4                                 # 004f42b2
    push edx                                     # 004f42b5
    push 0x55ddbc                                # 004f42b6
    push 0x63888b                                # 004f42bb
    call FUN_0050ca3e                            # 004f42c0
    add esp, 0xc                                 # 004f42c5
    push 0x0                                     # 004f42c8
    push 0x0                                     # 004f42ca
    push 0x63888b                                # 004f42cc
    call FUN_0052139c                            # 004f42d1
L_004f42d6:
    # block 0x004f42d6: entered by je at 0x004f42ad, 2 instruction(s), ends with forward jump to 0x004f4388
    {load} xor eax, eax                          # 004f42d6
    jmp.d32 L_004f4388                           # 004f42d8
L_004f42dd:
    # block 0x004f42dd: entered by jne at 0x004f426e; jge at 0x004f4291, 11 instruction(s), calls FUN_004f594d, ends with jne to 0x004f4314 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f42dd
    mov ecx, dword ptr [eax + field_15e]         # 004f42e0
    push ecx                                     # 004f42e6
    push 0x0                                     # 004f42e7
    mov edx, dword ptr [ebp + arg_8]             # 004f42e9
    and edx, 0xffff                              # 004f42ec
    push edx                                     # 004f42f2
    mov ecx, dword ptr [ebp - local_14]          # 004f42f3
    call FUN_004f594d                            # 004f42f6
    test eax, eax                                # 004f42fb
    jne.d8 L_004f4314                            # 004f42fd
    # block 0x004f42ff: entered by fall-through of jne at 0x004f42fd, 7 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f4388
    mov eax, dword ptr [ebp + arg_8]             # 004f42ff
    and eax, 0xffff                              # 004f4302
    push eax                                     # 004f4307
    mov ecx, dword ptr [ebp - local_14]          # 004f4308
    call FUN_004f356e                            # 004f430b
    {load} xor eax, eax                          # 004f4310
    jmp.d8 L_004f4388                            # 004f4312
L_004f4314:
    # block 0x004f4314: entered by jne at 0x004f42fd, 4 instruction(s), ends with jne to 0x004f4343 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004f4314
    movsx edx, word ptr [ecx + field_126]        # 004f4317
    cmp edx, 0x2                                 # 004f431e
    jne.d8 L_004f4343                            # 004f4321
    # block 0x004f4323: entered by fall-through of jne at 0x004f4321, 8 instruction(s), calls FUN_004fcef0, ends with forward jump to 0x004f4361
    mov eax, dword ptr [ebp - local_8]           # 004f4323
    add eax, 0x2f1                               # 004f4326
    push eax                                     # 004f432b
    call FUN_004fcef0                            # 004f432c
    add esp, 0x4                                 # 004f4331
    mov ecx, dword ptr [ebp - local_8]           # 004f4334
    mov dword ptr [ecx + field_2f1], 0x0         # 004f4337
    jmp.d8 L_004f4361                            # 004f4341
L_004f4343:
    # block 0x004f4343: entered by jne at 0x004f4321, 3 instruction(s), ends with je to 0x004f4361 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f4343
    cmp dword ptr [edx + field_156], 0x0         # 004f4346
    je.d8 L_004f4361                             # 004f434d
    # block 0x004f434f: entered by fall-through of je at 0x004f434d, 5 instruction(s), calls FUN_0050cee4, falls into the block at 0x004f4361
    mov eax, dword ptr [ebp - local_8]           # 004f434f
    mov ecx, dword ptr [eax + field_156]         # 004f4352
    push ecx                                     # 004f4358
    call FUN_0050cee4                            # 004f4359
    add esp, 0x4                                 # 004f435e
L_004f4361:
    # block 0x004f4361: entered by jmp at 0x004f4341; je at 0x004f434d, 9 instruction(s), calls FUN_004f684a, falls into the block at 0x004f4388
    mov edx, dword ptr [ebp - local_8]           # 004f4361
    mov dword ptr [edx + field_156], 0x0         # 004f4364
    mov eax, dword ptr [ebp + arg_8]             # 004f436e
    and eax, 0xffff                              # 004f4371
    push eax                                     # 004f4376
    mov ecx, dword ptr [ebp - local_14]          # 004f4377
    call FUN_004f684a                            # 004f437a
    mov ecx, dword ptr [ebp - local_14]          # 004f437f
    mov eax, dword ptr [ecx + field_3be]         # 004f4382
L_004f4388:
    # block 0x004f4388: entered by jmp at 0x004f3dec; jmp at 0x004f3eb3; jmp at 0x004f3f7c; jmp at 0x004f40fe; more, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 004f4388
    {load} mov esp, ebp                          # 004f4389
    pop ebp                                      # 004f438b
    ret 0x4                                      # 004f438c

