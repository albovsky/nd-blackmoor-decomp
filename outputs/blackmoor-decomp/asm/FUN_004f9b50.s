# FUN_004f9b50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f9b50
# extent:       0x004f9b50-0x004f9d18 (456 code bytes)
# span:         0x004f9b50-0x004f9d18 (code 456, tables 0, padding 0)
# sha256:       39fe1375198da8f5d79b802d154d94404e4ddbb3a26367f2c31facc382bd97a7
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_direct_sound_init_frame_anchor_pos
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4f9b50.c.txt, not original source) refers to the data labelled s_CDirectSound__InitFrameAnchorPos_0055f414
# name-note:    Computes the channel 3D anchor position from the frame angle and applies it; logs CDirectSound::InitFrameAnchorPos.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_2a7, field_3f4; [ecx + n] field_d1, field_dd, field_2a3, field_3ce, field_3f4; [edx + n] field_4, field_8, field_2ab, field_3da
# callees:      calls FUN_004ccb50, FUN_004ccc50, FUN_004f8f94, FUN_004f9040, FUN_0050ca3e, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 124 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_d1, 0xd1  # offset +0xd1
.equ field_dd, 0xdd  # offset +0xdd
.equ field_2a3, 0x2a3  # offset +0x2a3
.equ field_2a7, 0x2a7  # offset +0x2a7
.equ field_2ab, 0x2ab  # offset +0x2ab
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_3da, 0x3da  # offset +0x3da
.equ field_3f4, 0x3f4  # offset +0x3f4

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004ccb50, .text + (0x004ccb50 - 0x401000)
.set FUN_004ccc50, .text + (0x004ccc50 - 0x401000)
.set FUN_004f8f94, .text + (0x004f8f94 - 0x401000)
.set FUN_004f9040, .text + (0x004f9040 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f9b50 - 0x401000
.globl FUN_004f9b50
FUN_004f9b50:
    # block 0x004f9b50: entry, 23 instruction(s), ends with je to 0x004f9c76 (forward)
    push ebp                                     # 004f9b50
    {load} mov ebp, esp                          # 004f9b51
    sub esp, 0x28                                # 004f9b53
    mov dword ptr [ebp - local_20], ecx          # 004f9b56
    mov eax, dword ptr [ebp + arg_8]             # 004f9b59
    imul eax, eax, 0x5bb                         # 004f9b5c
    mov ecx, dword ptr [ebp - local_20]          # 004f9b62
    mov edx, dword ptr [ecx + field_3ce]         # 004f9b65
    {load} add edx, eax                          # 004f9b6b
    mov dword ptr [ebp - local_1c], edx          # 004f9b6d
    mov eax, dword ptr [ebp - local_1c]          # 004f9b70
    add eax, 0x19e                               # 004f9b73
    mov dword ptr [ebp - local_14], eax          # 004f9b78
    mov dword ptr [ebp - local_c], 0x0           # 004f9b7b
    mov dword ptr [ebp - local_8], 0x0           # 004f9b82
    mov ecx, dword ptr [ebp - local_14]          # 004f9b89
    fild dword ptr [ecx + field_dd]              # 004f9b8c
    fstp dword ptr [ebp - local_4]               # 004f9b92
    mov edx, dword ptr [ebp - local_20]          # 004f9b95
    movsx eax, word ptr [edx + field_3da]        # 004f9b98
    mov ecx, dword ptr [ebp - local_14]          # 004f9b9f
    cmp dword ptr [ecx + field_d1], eax          # 004f9ba2
    je.d32 L_004f9c76                            # 004f9ba8
    # block 0x004f9bae: entered by fall-through of je at 0x004f9ba8, 5 instruction(s), ends with jle to 0x004f9c02 (forward)
    mov edx, dword ptr [ebp - local_20]          # 004f9bae
    movsx eax, word ptr [edx + field_3da]        # 004f9bb1
    mov ecx, dword ptr [ebp - local_14]          # 004f9bb8
    cmp dword ptr [ecx + field_d1], eax          # 004f9bbb
    jle.d8 L_004f9c02                            # 004f9bc1
    # block 0x004f9bc3: entered by fall-through of jle at 0x004f9bc1, 16 instruction(s), ends with forward jump to 0x004f9c2e
    mov edx, dword ptr [ebp - local_20]          # 004f9bc3
    movsx eax, word ptr [edx + field_3da]        # 004f9bc6
    mov ecx, dword ptr [ebp - local_14]          # 004f9bcd
    mov edx, dword ptr [ecx + field_d1]          # 004f9bd0
    {load} sub edx, eax                          # 004f9bd6
    mov word ptr [ebp - local_10], dx            # 004f9bd8
    movsx eax, word ptr [ebp - local_10]         # 004f9bdc
    mov ecx, dword ptr [ebp - local_20]          # 004f9be0
    movsx edx, word ptr [ecx + field_3f4]        # 004f9be3
    imul eax, edx                                # 004f9bea
    mov word ptr [ebp - local_18], ax            # 004f9bed
    movsx eax, word ptr [ebp - local_18]         # 004f9bf1
    mov ecx, 0x168                               # 004f9bf5
    {load} sub ecx, eax                          # 004f9bfa
    mov word ptr [ebp - local_18], cx            # 004f9bfc
    jmp.d8 L_004f9c2e                            # 004f9c00
L_004f9c02:
    # block 0x004f9c02: entered by jle at 0x004f9bc1, 10 instruction(s), falls into the block at 0x004f9c2e
    mov edx, dword ptr [ebp - local_20]          # 004f9c02
    movsx eax, word ptr [edx + field_3da]        # 004f9c05
    mov ecx, dword ptr [ebp - local_14]          # 004f9c0c
    sub eax, dword ptr [ecx + field_d1]          # 004f9c0f
    mov word ptr [ebp - local_10], ax            # 004f9c15
    movsx edx, word ptr [ebp - local_10]         # 004f9c19
    mov eax, dword ptr [ebp - local_20]          # 004f9c1d
    movsx ecx, word ptr [eax + field_3f4]        # 004f9c20
    imul edx, ecx                                # 004f9c27
    mov word ptr [ebp - local_18], dx            # 004f9c2a
L_004f9c2e:
    # block 0x004f9c2e: entered by jmp at 0x004f9c00, 22 instruction(s), calls FUN_004ccb50, FUN_004ccc50, ends with forward jump to 0x004f9c90
    movsx edx, word ptr [ebp - local_18]         # 004f9c2e
    mov dword ptr [ebp - local_24], edx          # 004f9c32
    fild dword ptr [ebp - local_24]              # 004f9c35
    fstp dword ptr [ebp - local_28]              # 004f9c38
    mov eax, dword ptr [ebp - local_28]          # 004f9c3b
    push eax                                     # 004f9c3e
    mov ecx, dword ptr [ebp - local_20]          # 004f9c3f
    add ecx, 0x3f6                               # 004f9c42
    push ecx                                     # 004f9c48
    mov ecx, 0x630a7e                            # 004f9c49
    call FUN_004ccb50                            # 004f9c4e
    lea edx, [ebp - local_c]                     # 004f9c53
    push edx                                     # 004f9c56
    mov eax, dword ptr [ebp - local_1c]          # 004f9c57
    add eax, 0x2a3                               # 004f9c5a
    push eax                                     # 004f9c5f
    mov ecx, dword ptr [ebp - local_20]          # 004f9c60
    add ecx, 0x3f6                               # 004f9c63
    push ecx                                     # 004f9c69
    mov ecx, 0x630a7e                            # 004f9c6a
    call FUN_004ccc50                            # 004f9c6f
    jmp.d8 L_004f9c90                            # 004f9c74
L_004f9c76:
    # block 0x004f9c76: entered by je at 0x004f9ba8, 8 instruction(s), falls into the block at 0x004f9c90
    mov edx, dword ptr [ebp - local_1c]          # 004f9c76
    add edx, 0x2a3                               # 004f9c79
    mov eax, dword ptr [ebp - local_c]           # 004f9c7f
    mov dword ptr [edx], eax                     # 004f9c82
    mov ecx, dword ptr [ebp - local_8]           # 004f9c84
    mov dword ptr [edx + field_4], ecx           # 004f9c87
    mov eax, dword ptr [ebp - local_4]           # 004f9c8a
    mov dword ptr [edx + field_8], eax           # 004f9c8d
L_004f9c90:
    # block 0x004f9c90: entered by jmp at 0x004f9c74, 14 instruction(s), calls FUN_004f8f94, FUN_004f9040, ends with je to 0x004f9d12 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004f9c90
    push ecx                                     # 004f9c93
    mov ecx, dword ptr [ebp - local_20]          # 004f9c94
    call FUN_004f8f94                            # 004f9c97
    mov edx, dword ptr [ebp - local_1c]          # 004f9c9c
    add edx, 0x2a3                               # 004f9c9f
    push edx                                     # 004f9ca5
    mov eax, dword ptr [ebp + arg_8]             # 004f9ca6
    push eax                                     # 004f9ca9
    mov ecx, dword ptr [ebp - local_20]          # 004f9caa
    call FUN_004f9040                            # 004f9cad
    movsx ecx, word ptr [0x63a4cd]               # 004f9cb2
    test ecx, ecx                                # 004f9cb9
    je.d8 L_004f9d12                             # 004f9cbb
    # block 0x004f9cbd: entered by fall-through of je at 0x004f9cbb, 23 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f9d12
    mov edx, dword ptr [ebp - local_1c]          # 004f9cbd
    fld dword ptr [edx + field_2ab]              # 004f9cc0
    sub esp, 0x8                                 # 004f9cc6
    fstp qword ptr [esp]                         # 004f9cc9
    mov eax, dword ptr [ebp - local_1c]          # 004f9ccc
    fld dword ptr [eax + field_2a7]              # 004f9ccf
    sub esp, 0x8                                 # 004f9cd5
    fstp qword ptr [esp]                         # 004f9cd8
    mov ecx, dword ptr [ebp - local_1c]          # 004f9cdb
    fld dword ptr [ecx + field_2a3]              # 004f9cde
    sub esp, 0x8                                 # 004f9ce4
    fstp qword ptr [esp]                         # 004f9ce7
    movsx edx, word ptr [ebp - local_18]         # 004f9cea
    push edx                                     # 004f9cee
    mov eax, dword ptr [ebp + arg_8]             # 004f9cef
    push eax                                     # 004f9cf2
    push 0x55f414                                # 004f9cf3
    push 0x63888b                                # 004f9cf8
    call FUN_0050ca3e                            # 004f9cfd
    add esp, 0x28                                # 004f9d02
    push 0x63888b                                # 004f9d05
    call FUN_0044a2b7                            # 004f9d0a
    add esp, 0x4                                 # 004f9d0f
L_004f9d12:
    # block 0x004f9d12: entered by je at 0x004f9cbb, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004f9d12
    pop ebp                                      # 004f9d14
    ret 0x4                                      # 004f9d15

