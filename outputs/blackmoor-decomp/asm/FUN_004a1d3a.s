# FUN_004a1d3a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a1d3a
# extent:       0x004a1d3a-0x004a1e16 (220 code bytes)
# span:         0x004a1d3a-0x004a1e16 (code 220, tables 0, padding 0)
# sha256:       75ceb03bb12b0afcfc2ff73d8460f2c58d342742a183912a5c505488aaf3022d
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a1d3a_lifted
# naming:       native port src/original_methods_fl41.c:m4a1d3a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 3 seeds; oracle: 70/70 instructions, 4/4 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [edx + n] field_151
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4a1d3a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 70 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_151, 0x151  # offset +0x151

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004a1d3a - 0x401000
.globl FUN_004a1d3a
FUN_004a1d3a:
    # block 0x004a1d3a: entry, 24 instruction(s), calls FUN_0051dc43, ends with jne to 0x004a1dc1 (forward)
    push ebp                                     # 004a1d3a
    {load} mov ebp, esp                          # 004a1d3b
    sub esp, 0x10                                # 004a1d3d
    push esi                                     # 004a1d40
    push edi                                     # 004a1d41
    mov dword ptr [ebp - local_10], ecx          # 004a1d42
    mov eax, dword ptr [ebp + arg_c]             # 004a1d45
    mov ecx, dword ptr [eax]                     # 004a1d48
    mov dword ptr [ebp - local_4], ecx           # 004a1d4a
    mov edx, dword ptr [ebp - local_4]           # 004a1d4d
    movsx eax, word ptr [edx + field_151]        # 004a1d50
    imul eax, eax, 0x1e5                         # 004a1d57
    add eax, 0x153                               # 004a1d5d
    mov dword ptr [ebp - local_8], eax           # 004a1d62
    mov ecx, dword ptr [ebp - local_8]           # 004a1d65
    push ecx                                     # 004a1d68
    call FUN_0051dc43                            # 004a1d69
    add esp, 0x4                                 # 004a1d6e
    mov dword ptr [ebp - local_c], eax           # 004a1d71
    mov edx, dword ptr [ebp + arg_8]             # 004a1d74
    mov eax, dword ptr [ebp - local_c]           # 004a1d77
    mov dword ptr [edx], eax                     # 004a1d7a
    cmp dword ptr [ebp - local_c], 0x0           # 004a1d7c
    jne.d8 L_004a1dc1                            # 004a1d80
    # block 0x004a1d82: entered by fall-through of jne at 0x004a1d80, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004a1dc1
    movsx ecx, word ptr [0x5c39e3]               # 004a1d82
    push ecx                                     # 004a1d89
    mov edx, dword ptr [0x5bb57b]                # 004a1d8a
    push edx                                     # 004a1d90
    push 0x5502dc                                # 004a1d91
    push 0x63888b                                # 004a1d96
    call FUN_0050ca3e                            # 004a1d9b
    add esp, 0x10                                # 004a1da0
    push 0x63888b                                # 004a1da3
    push 0x550308                                # 004a1da8
    mov ecx, 0x583979                            # 004a1dad
    call FUN_0042639d                            # 004a1db2
    mov ecx, 0x5cf659                            # 004a1db7
    call FUN_004c97b4                            # 004a1dbc
L_004a1dc1:
    # block 0x004a1dc1: entered by jne at 0x004a1d80, 24 instruction(s), ends with je to 0x004a1e0e (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004a1dc1
    mov eax, dword ptr [ebp + arg_c]             # 004a1dc4
    mov esi, dword ptr [eax]                     # 004a1dc7
    mov edx, dword ptr [ebp + arg_8]             # 004a1dc9
    mov edi, dword ptr [edx]                     # 004a1dcc
    {load} mov eax, ecx                          # 004a1dce
    shr ecx, 0x2                                 # 004a1dd0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a1dd3
    {load} mov ecx, eax                          # 004a1dd5
    and ecx, 0x3                                 # 004a1dd7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004a1dda
    mov ecx, dword ptr [ebp + arg_10]            # 004a1ddc
    mov edx, dword ptr [ecx]                     # 004a1ddf
    add edx, dword ptr [ebp - local_8]           # 004a1de1
    mov eax, dword ptr [ebp + arg_10]            # 004a1de4
    mov dword ptr [eax], edx                     # 004a1de7
    mov ecx, dword ptr [ebp + arg_c]             # 004a1de9
    mov edx, dword ptr [ecx]                     # 004a1dec
    add edx, dword ptr [ebp - local_8]           # 004a1dee
    mov eax, dword ptr [ebp + arg_c]             # 004a1df1
    mov dword ptr [eax], edx                     # 004a1df4
    movsx ecx, word ptr [0x63a4cd]               # 004a1df6
    test ecx, ecx                                # 004a1dfd
    je.d8 L_004a1e0e                             # 004a1dff
    # block 0x004a1e01: entered by fall-through of je at 0x004a1dff, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004a1e0e
    push 0x550324                                # 004a1e01
    call FUN_0044a2b7                            # 004a1e06
    add esp, 0x4                                 # 004a1e0b
L_004a1e0e:
    # block 0x004a1e0e: entered by je at 0x004a1dff, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004a1e0e
    pop esi                                      # 004a1e0f
    {load} mov esp, ebp                          # 004a1e10
    pop ebp                                      # 004a1e12
    ret 0xc                                      # 004a1e13

