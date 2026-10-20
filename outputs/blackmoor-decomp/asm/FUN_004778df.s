# FUN_004778df
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004778df
# extent:       0x004778df-0x004780d2 (2035 code bytes)
# span:         0x004778df-0x004780e0 (code 2035, tables 0, padding 14)
# sha256:       7afe86ef149ed90174e93656e74fee3d1194df7a26b511f605166c5f659b6733
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4778df_render
# naming:       native port src/original_methods_fl22a.c:m4778df_render (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m4778df_render. Direct: objects, ordered calls, probes. Unicorn differential: 600 fixtures, 514/514 instructions, 5000 ordered host calls. Window covers all 2035 bytes. See tasks/fl22a-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_30, local_34, local_38, local_3c, local_40, local_44, local_48
# fields:       [eax + n] field_678, field_67c, field_680, field_698, field_6b4, field_6b8, field_6c4, field_6c8, field_6d4; [ecx + n] field_42, field_58, field_238, field_23a, field_63e, field_678, field_684, field_6a4, field_6ac, field_6b0, field_6bc, field_6c0 and 8 more; [edx + n] field_44, field_23a, field_63d, field_67c, field_680, field_684, field_69c, field_6a0, field_6a8, field_6b8, field_6bc, field_6c0 and 5 more
# callees:      calls FUN_004c5377, FUN_00475cc4, FUN_004d3836, FUN_0050ca3e
# track-n:      outputs/blackmoor-decomp/src/action_family_e4_runtime.h:e4r_render (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 514 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_minus_6, 0x6  # offset -0x6
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ field_42, 0x42  # offset +0x42
.equ field_44, 0x44  # offset +0x44
.equ field_58, 0x58  # offset +0x58
.equ field_238, 0x238  # offset +0x238
.equ field_23a, 0x23a  # offset +0x23a
.equ field_63d, 0x63d  # offset +0x63d
.equ field_63e, 0x63e  # offset +0x63e
.equ field_678, 0x678  # offset +0x678
.equ field_67c, 0x67c  # offset +0x67c
.equ field_680, 0x680  # offset +0x680
.equ field_684, 0x684  # offset +0x684
.equ field_698, 0x698  # offset +0x698
.equ field_69c, 0x69c  # offset +0x69c
.equ field_6a0, 0x6a0  # offset +0x6a0
.equ field_6a4, 0x6a4  # offset +0x6a4
.equ field_6a8, 0x6a8  # offset +0x6a8
.equ field_6ac, 0x6ac  # offset +0x6ac
.equ field_6b0, 0x6b0  # offset +0x6b0
.equ field_6b4, 0x6b4  # offset +0x6b4
.equ field_6b8, 0x6b8  # offset +0x6b8
.equ field_6bc, 0x6bc  # offset +0x6bc
.equ field_6c0, 0x6c0  # offset +0x6c0
.equ field_6c4, 0x6c4  # offset +0x6c4
.equ field_6c8, 0x6c8  # offset +0x6c8
.equ field_6cc, 0x6cc  # offset +0x6cc
.equ field_6d0, 0x6d0  # offset +0x6d0
.equ field_6d4, 0x6d4  # offset +0x6d4
.equ field_6d8, 0x6d8  # offset +0x6d8
.equ field_6dc, 0x6dc  # offset +0x6dc
.equ field_6e0, 0x6e0  # offset +0x6e0
.equ field_6e4, 0x6e4  # offset +0x6e4

# --- external targets -----------------------------------------------
.set FUN_00475cc4, .text + (0x00475cc4 - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004d3836, .text + (0x004d3836 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004778df - 0x401000
.globl FUN_004778df
FUN_004778df:
    # block 0x004778df: entry, 13 instruction(s), ends with je to 0x00477936 (forward)
    push ebp                                     # 004778df
    {load} mov ebp, esp                          # 004778e0
    sub esp, 0x48                                # 004778e2
    push esi                                     # 004778e5
    push edi                                     # 004778e6
    movsx eax, word ptr [0x622fc4]               # 004778e7
    imul eax, eax, 0x8d                          # 004778ee
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004778f4
    mov dword ptr [ebp - local_4], ecx           # 004778fa
    {load} xor edx, edx                          # 004778fd
    mov dl, byte ptr [0x6237a4]                  # 004778ff
    test edx, edx                                # 00477905
    je.d8 L_00477936                             # 00477907
    # block 0x00477909: entered by fall-through of je at 0x00477907, 10 instruction(s), calls FUN_004c5377, falls into the block at 0x00477936
    push 0x54c9b0                                # 00477909
    push 0x583186                                # 0047790e
    push 0x583196                                # 00477913
    mov eax, dword ptr [0x5cf665]                # 00477918
    push eax                                     # 0047791d
    mov ecx, dword ptr [0x5d15e3]                # 0047791e
    push ecx                                     # 00477924
    mov ecx, 0x5cf659                            # 00477925
    call FUN_004c5377                            # 0047792a
    mov byte ptr [0x6237a4], 0x0                 # 0047792f
L_00477936:
    # block 0x00477936: entered by je at 0x00477907, 2 instruction(s), ends with je to 0x00477f50 (forward)
    cmp dword ptr [0x622fce], 0x6                # 00477936
    je.d32 L_00477f50                            # 0047793d
    # block 0x00477943: entered by fall-through of je at 0x0047793d, 2 instruction(s), ends with forward jump to 0x00477957
    mov word ptr [ebp - local_8], 0x0            # 00477943
    jmp.d8 L_00477957                            # 00477949
L_0047794b:
    # block 0x0047794b: entered by jmp at 0x00477a84, 3 instruction(s), falls into the block at 0x00477957
    mov dx, word ptr [ebp - local_8]             # 0047794b
    add dx, 0x1                                  # 0047794f
    mov word ptr [ebp - local_8], dx             # 00477953
L_00477957:
    # block 0x00477957: entered by jmp at 0x00477949, 5 instruction(s), ends with jge to 0x00477a89 (forward)
    movsx eax, word ptr [ebp - local_8]          # 00477957
    mov ecx, dword ptr [ebp - local_4]           # 0047795b
    movsx edx, word ptr [ecx + field_42]         # 0047795e
    {load} cmp eax, edx                          # 00477962
    jge.d32 L_00477a89                           # 00477964
    # block 0x0047796a: entered by fall-through of jge at 0x00477964, 2 instruction(s), ends with forward jump to 0x0047797e
    mov word ptr [ebp - local_44], 0x0           # 0047796a
    jmp.d8 L_0047797e                            # 00477970
L_00477972:
    # block 0x00477972: entered by jmp at 0x00477a7f, 3 instruction(s), falls into the block at 0x0047797e
    mov ax, word ptr [ebp - local_44]            # 00477972
    .insn 0x66, 0x05, 0x0001{:u16}               # 00477976
    mov word ptr [ebp - local_44], ax            # 0047797a
L_0047797e:
    # block 0x0047797e: entered by jmp at 0x00477970, 5 instruction(s), ends with jge to 0x00477a84 (forward)
    movsx ecx, word ptr [ebp - local_44]         # 0047797e
    mov edx, dword ptr [ebp - local_4]           # 00477982
    movsx eax, word ptr [edx + field_44]         # 00477985
    {load} cmp ecx, eax                          # 00477989
    jge.d32 L_00477a84                           # 0047798b
    # block 0x00477991: entered by fall-through of jge at 0x0047798b, 8 instruction(s), ends with je to 0x00477a7f (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00477991
    imul ecx, ecx, 0xc8                          # 00477995
    movsx edx, word ptr [ebp - local_44]         # 0047799b
    imul edx, edx, 0x14                          # 0047799f
    {load} xor eax, eax                          # 004779a2
    mov al, byte ptr [ecx + edx + 0x622fd2]      # 004779a4
    test eax, eax                                # 004779ab
    je.d32 L_00477a7f                            # 004779ad
    # block 0x004779b3: entered by fall-through of je at 0x004779ad, 8 instruction(s), ends with jne to 0x00477a36 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004779b3
    imul ecx, ecx, 0xc8                          # 004779b7
    movsx edx, word ptr [ebp - local_44]         # 004779bd
    imul edx, edx, 0x14                          # 004779c1
    {load} xor eax, eax                          # 004779c4
    mov al, byte ptr [ecx + edx + 0x622fd3]      # 004779c6
    test eax, eax                                # 004779cd
    jne.d8 L_00477a36                            # 004779cf
    # block 0x004779d1: entered by fall-through of jne at 0x004779cf, 25 instruction(s), calls FUN_004c5377, ends with forward jump to 0x00477a7f
    push 0x54c9d8                                # 004779d1
    movsx ecx, word ptr [ebp - local_8]          # 004779d6
    imul ecx, ecx, 0xc8                          # 004779da
    movsx edx, word ptr [ebp - local_44]         # 004779e0
    imul edx, edx, 0x14                          # 004779e4
    lea eax, [ecx + edx + 0x622fd6]              # 004779e7
    push eax                                     # 004779ee
    movsx ecx, word ptr [ebp - local_8]          # 004779ef
    imul ecx, ecx, 0xc8                          # 004779f3
    movsx edx, word ptr [ebp - local_44]         # 004779f9
    imul edx, edx, 0x14                          # 004779fd
    movsx eax, word ptr [ecx + edx + 0x622fd4]   # 00477a00
    shl eax, 0x4                                 # 00477a08
    mov ecx, dword ptr [ebp - local_4]           # 00477a0b
    lea edx, [ecx + eax + field_58]              # 00477a0e
    push edx                                     # 00477a12
    mov eax, dword ptr [0x5cf665]                # 00477a13
    push eax                                     # 00477a18
    movsx ecx, word ptr [0x622fc2]               # 00477a19
    imul ecx, ecx, 0x4a                          # 00477a20
    mov edx, dword ptr [ecx + 0x5d1599]          # 00477a23
    push edx                                     # 00477a29
    mov ecx, 0x5cf659                            # 00477a2a
    call FUN_004c5377                            # 00477a2f
    jmp.d8 L_00477a7f                            # 00477a34
L_00477a36:
    # block 0x00477a36: entered by jne at 0x004779cf, 18 instruction(s), calls FUN_004c5377, falls into the block at 0x00477a7f
    push 0x54c9f0                                # 00477a36
    movsx eax, word ptr [ebp - local_8]          # 00477a3b
    imul eax, eax, 0xc8                          # 00477a3f
    movsx ecx, word ptr [ebp - local_44]         # 00477a45
    imul ecx, ecx, 0x14                          # 00477a49
    lea edx, [eax + ecx + 0x622fd6]              # 00477a4c
    push edx                                     # 00477a53
    mov eax, dword ptr [ebp - local_4]           # 00477a54
    add eax, 0x646                               # 00477a57
    push eax                                     # 00477a5c
    mov ecx, dword ptr [0x5cf665]                # 00477a5d
    push ecx                                     # 00477a63
    movsx edx, word ptr [0x622fc2]               # 00477a64
    imul edx, edx, 0x4a                          # 00477a6b
    mov eax, dword ptr [edx + 0x5d1599]          # 00477a6e
    push eax                                     # 00477a74
    mov ecx, 0x5cf659                            # 00477a75
    call FUN_004c5377                            # 00477a7a
L_00477a7f:
    # block 0x00477a7f: entered by je at 0x004779ad; jmp at 0x00477a34, 1 instruction(s), ends with backward jump to 0x00477972
    jmp.d32 L_00477972                           # 00477a7f
L_00477a84:
    # block 0x00477a84: entered by jge at 0x0047798b, 1 instruction(s), ends with backward jump to 0x0047794b
    jmp.d32 L_0047794b                           # 00477a84
L_00477a89:
    # block 0x00477a89: entered by jge at 0x00477964, 5 instruction(s), ends with je to 0x00477c83 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00477a89
    {load} xor edx, edx                          # 00477a8c
    mov dl, byte ptr [ecx + field_238]           # 00477a8e
    test edx, edx                                # 00477a94
    je.d32 L_00477c83                            # 00477a96
    # block 0x00477a9c: entered by fall-through of je at 0x00477a96, 4 instruction(s), ends with je to 0x00477b88 (forward)
    {load} xor eax, eax                          # 00477a9c
    mov al, byte ptr [0x6237a2]                  # 00477a9e
    test eax, eax                                # 00477aa3
    je.d32 L_00477b88                            # 00477aa5
    # block 0x00477aab: entered by fall-through of je at 0x00477aa5, 51 instruction(s), calls FUN_00475cc4, FUN_004c5377, ends with forward jump to 0x00477c83
    mov ecx, dword ptr [ebp - local_4]           # 00477aab
    mov edx, dword ptr [ecx + field_6bc]         # 00477aae
    add edx, dword ptr [0x58318a]                # 00477ab4
    mov dword ptr [ebp - local_3c], edx          # 00477aba
    mov eax, dword ptr [ebp - local_4]           # 00477abd
    mov ecx, dword ptr [eax + field_6c4]         # 00477ac0
    add ecx, dword ptr [0x58318a]                # 00477ac6
    mov dword ptr [ebp - local_34], ecx          # 00477acc
    mov edx, dword ptr [ebp - local_4]           # 00477acf
    mov eax, dword ptr [edx + field_6b8]         # 00477ad2
    add eax, dword ptr [0x583186]                # 00477ad8
    mov dword ptr [ebp - local_40], eax          # 00477ade
    mov ecx, dword ptr [ebp - local_4]           # 00477ae1
    mov edx, dword ptr [ecx + field_6c0]         # 00477ae4
    add edx, dword ptr [0x583186]                # 00477aea
    mov dword ptr [ebp - local_38], edx          # 00477af0
    mov eax, dword ptr [ebp - local_4]           # 00477af3
    add eax, 0x6b8                               # 00477af6
    push eax                                     # 00477afb
    push 0x6237a6                                # 00477afc
    mov ecx, 0x622fa2                            # 00477b01
    call FUN_00475cc4                            # 00477b06
    mov ecx, dword ptr [ebp - local_4]           # 00477b0b
    mov edx, dword ptr [ecx + field_6cc]         # 00477b0e
    add edx, dword ptr [0x58318a]                # 00477b14
    mov dword ptr [ebp - local_3c], edx          # 00477b1a
    mov eax, dword ptr [ebp - local_4]           # 00477b1d
    mov ecx, dword ptr [eax + field_6d4]         # 00477b20
    add ecx, dword ptr [0x58318a]                # 00477b26
    mov dword ptr [ebp - local_34], ecx          # 00477b2c
    mov edx, dword ptr [ebp - local_4]           # 00477b2f
    mov eax, dword ptr [edx + field_6c8]         # 00477b32
    add eax, dword ptr [0x583186]                # 00477b38
    mov dword ptr [ebp - local_40], eax          # 00477b3e
    mov ecx, dword ptr [ebp - local_4]           # 00477b41
    mov edx, dword ptr [ecx + field_6d0]         # 00477b44
    add edx, dword ptr [0x583186]                # 00477b4a
    mov dword ptr [ebp - local_38], edx          # 00477b50
    push 0x54ca08                                # 00477b53
    lea eax, [ebp - local_40]                    # 00477b58
    push eax                                     # 00477b5b
    push 0x6237c7                                # 00477b5c
    mov ecx, dword ptr [0x5cf665]                # 00477b61
    push ecx                                     # 00477b67
    movsx edx, word ptr [0x622fc2]               # 00477b68
    imul edx, edx, 0x4a                          # 00477b6f
    mov eax, dword ptr [edx + 0x5d1599]          # 00477b72
    push eax                                     # 00477b78
    mov ecx, 0x5cf659                            # 00477b79
    call FUN_004c5377                            # 00477b7e
    jmp.d32 L_00477c83                           # 00477b83
L_00477b88:
    # block 0x00477b88: entered by je at 0x00477aa5, 4 instruction(s), ends with je to 0x00477c83 (forward)
    {load} xor ecx, ecx                          # 00477b88
    mov cl, byte ptr [0x6237a5]                  # 00477b8a
    test ecx, ecx                                # 00477b90
    je.d32 L_00477c83                            # 00477b92
    # block 0x00477b98: entered by fall-through of je at 0x00477b92, 57 instruction(s), calls FUN_004c5377, falls into the block at 0x00477c83
    mov edx, dword ptr [ebp - local_4]           # 00477b98
    mov eax, dword ptr [edx + field_6bc]         # 00477b9b
    add eax, dword ptr [0x58318a]                # 00477ba1
    mov dword ptr [ebp - local_3c], eax          # 00477ba7
    mov ecx, dword ptr [ebp - local_4]           # 00477baa
    mov edx, dword ptr [ecx + field_6c4]         # 00477bad
    add edx, dword ptr [0x58318a]                # 00477bb3
    mov dword ptr [ebp - local_34], edx          # 00477bb9
    mov eax, dword ptr [ebp - local_4]           # 00477bbc
    mov ecx, dword ptr [eax + field_6b8]         # 00477bbf
    add ecx, dword ptr [0x583186]                # 00477bc5
    mov dword ptr [ebp - local_40], ecx          # 00477bcb
    mov edx, dword ptr [ebp - local_4]           # 00477bce
    mov eax, dword ptr [edx + field_6c0]         # 00477bd1
    add eax, dword ptr [0x583186]                # 00477bd7
    mov dword ptr [ebp - local_38], eax          # 00477bdd
    push 0x54ca18                                # 00477be0
    lea ecx, [ebp - local_40]                    # 00477be5
    push ecx                                     # 00477be8
    mov edx, dword ptr [ebp - local_4]           # 00477be9
    add edx, 0x6b8                               # 00477bec
    push edx                                     # 00477bf2
    mov eax, dword ptr [0x5cf665]                # 00477bf3
    push eax                                     # 00477bf8
    mov ecx, dword ptr [0x5d15e3]                # 00477bf9
    push ecx                                     # 00477bff
    mov ecx, 0x5cf659                            # 00477c00
    call FUN_004c5377                            # 00477c05
    mov edx, dword ptr [ebp - local_4]           # 00477c0a
    mov eax, dword ptr [edx + field_6cc]         # 00477c0d
    add eax, dword ptr [0x58318a]                # 00477c13
    mov dword ptr [ebp - local_3c], eax          # 00477c19
    mov ecx, dword ptr [ebp - local_4]           # 00477c1c
    mov edx, dword ptr [ecx + field_6d4]         # 00477c1f
    add edx, dword ptr [0x58318a]                # 00477c25
    mov dword ptr [ebp - local_34], edx          # 00477c2b
    mov eax, dword ptr [ebp - local_4]           # 00477c2e
    mov ecx, dword ptr [eax + field_6c8]         # 00477c31
    add ecx, dword ptr [0x583186]                # 00477c37
    mov dword ptr [ebp - local_40], ecx          # 00477c3d
    mov edx, dword ptr [ebp - local_4]           # 00477c40
    mov eax, dword ptr [edx + field_6d0]         # 00477c43
    add eax, dword ptr [0x583186]                # 00477c49
    mov dword ptr [ebp - local_38], eax          # 00477c4f
    push 0x54ca3c                                # 00477c52
    lea ecx, [ebp - local_40]                    # 00477c57
    push ecx                                     # 00477c5a
    mov edx, dword ptr [ebp - local_4]           # 00477c5b
    add edx, 0x6c8                               # 00477c5e
    push edx                                     # 00477c64
    mov eax, dword ptr [0x5cf665]                # 00477c65
    push eax                                     # 00477c6a
    mov ecx, dword ptr [0x5d15e3]                # 00477c6b
    push ecx                                     # 00477c71
    mov ecx, 0x5cf659                            # 00477c72
    call FUN_004c5377                            # 00477c77
    mov byte ptr [0x6237a5], 0x0                 # 00477c7c
L_00477c83:
    # block 0x00477c83: entered by je at 0x00477a96; jmp at 0x00477b83; je at 0x00477b92, 5 instruction(s), ends with je to 0x00477d34 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00477c83
    {load} xor eax, eax                          # 00477c86
    mov al, byte ptr [edx + field_63d]           # 00477c88
    test eax, eax                                # 00477c8e
    je.d32 L_00477d34                            # 00477c90
    # block 0x00477c96: entered by fall-through of je at 0x00477c90, 4 instruction(s), ends with je to 0x00477d1b (forward)
    {load} xor ecx, ecx                          # 00477c96
    mov cl, byte ptr [0x6237a3]                  # 00477c98
    test ecx, ecx                                # 00477c9e
    je.d8 L_00477d1b                             # 00477ca0
    # block 0x00477ca2: entered by fall-through of je at 0x00477ca0, 29 instruction(s), calls FUN_004c5377, falls into the block at 0x00477d1b
    mov edx, dword ptr [ebp - local_4]           # 00477ca2
    mov eax, dword ptr [edx + field_69c]         # 00477ca5
    add eax, dword ptr [0x58318a]                # 00477cab
    mov dword ptr [ebp - local_3c], eax          # 00477cb1
    mov ecx, dword ptr [ebp - local_4]           # 00477cb4
    mov edx, dword ptr [ecx + field_6a4]         # 00477cb7
    add edx, dword ptr [0x58318a]                # 00477cbd
    mov dword ptr [ebp - local_34], edx          # 00477cc3
    mov eax, dword ptr [ebp - local_4]           # 00477cc6
    mov ecx, dword ptr [eax + field_698]         # 00477cc9
    add ecx, dword ptr [0x583186]                # 00477ccf
    mov dword ptr [ebp - local_40], ecx          # 00477cd5
    mov edx, dword ptr [ebp - local_4]           # 00477cd8
    mov eax, dword ptr [edx + field_6a0]         # 00477cdb
    add eax, dword ptr [0x583186]                # 00477ce1
    mov dword ptr [ebp - local_38], eax          # 00477ce7
    push 0x54ca4c                                # 00477cea
    lea ecx, [ebp - local_40]                    # 00477cef
    push ecx                                     # 00477cf2
    mov edx, dword ptr [ebp - local_4]           # 00477cf3
    add edx, 0x698                               # 00477cf6
    push edx                                     # 00477cfc
    mov eax, dword ptr [0x5cf665]                # 00477cfd
    push eax                                     # 00477d02
    mov ecx, dword ptr [0x5d15e3]                # 00477d03
    push ecx                                     # 00477d09
    mov ecx, 0x5cf659                            # 00477d0a
    call FUN_004c5377                            # 00477d0f
    mov byte ptr [0x6237a3], 0x0                 # 00477d14
L_00477d1b:
    # block 0x00477d1b: entered by je at 0x00477ca0, 6 instruction(s), calls FUN_00475cc4, falls into the block at 0x00477d34
    mov edx, dword ptr [ebp - local_4]           # 00477d1b
    add edx, 0x698                               # 00477d1e
    push edx                                     # 00477d24
    push 0x6237d7                                # 00477d25
    mov ecx, 0x622fa2                            # 00477d2a
    call FUN_00475cc4                            # 00477d2f
L_00477d34:
    # block 0x00477d34: entered by je at 0x00477c90, 6 instruction(s), ends with je to 0x00477dd8 (forward)
    mov edi, 0x63a88c                            # 00477d34
    mov esi, 0x6237f8                            # 00477d39
    mov ecx, 0x1                                 # 00477d3e
    {load} xor eax, eax                          # 00477d43
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00477d45
    je.d32 L_00477dd8                            # 00477d47
    # block 0x00477d4d: entered by fall-through of je at 0x00477d47, 34 instruction(s), calls FUN_004c5377, FUN_00475cc4, falls into the block at 0x00477dd8
    mov ecx, dword ptr [ebp - local_4]           # 00477d4d
    mov edx, dword ptr [ecx + field_6ac]         # 00477d50
    add edx, dword ptr [0x58318a]                # 00477d56
    mov dword ptr [ebp - local_3c], edx          # 00477d5c
    mov eax, dword ptr [ebp - local_4]           # 00477d5f
    mov ecx, dword ptr [eax + field_6b4]         # 00477d62
    add ecx, dword ptr [0x58318a]                # 00477d68
    mov dword ptr [ebp - local_34], ecx          # 00477d6e
    mov edx, dword ptr [ebp - local_4]           # 00477d71
    mov eax, dword ptr [edx + field_6a8]         # 00477d74
    add eax, dword ptr [0x583186]                # 00477d7a
    mov dword ptr [ebp - local_40], eax          # 00477d80
    mov ecx, dword ptr [ebp - local_4]           # 00477d83
    mov edx, dword ptr [ecx + field_6b0]         # 00477d86
    add edx, dword ptr [0x583186]                # 00477d8c
    mov dword ptr [ebp - local_38], edx          # 00477d92
    push 0x54ca70                                # 00477d95
    lea eax, [ebp - local_40]                    # 00477d9a
    push eax                                     # 00477d9d
    mov ecx, dword ptr [ebp - local_4]           # 00477d9e
    add ecx, 0x6a8                               # 00477da1
    push ecx                                     # 00477da7
    mov edx, dword ptr [0x5cf665]                # 00477da8
    push edx                                     # 00477dae
    mov eax, dword ptr [0x5d15e3]                # 00477daf
    push eax                                     # 00477db4
    mov ecx, 0x5cf659                            # 00477db5
    call FUN_004c5377                            # 00477dba
    mov ecx, dword ptr [ebp - local_4]           # 00477dbf
    add ecx, 0x6a8                               # 00477dc2
    push ecx                                     # 00477dc8
    push 0x6237f8                                # 00477dc9
    mov ecx, 0x622fa2                            # 00477dce
    call FUN_00475cc4                            # 00477dd3
L_00477dd8:
    # block 0x00477dd8: entered by je at 0x00477d47, 4 instruction(s), ends with je to 0x00477e63 (forward)
    {load} xor edx, edx                          # 00477dd8
    mov dl, byte ptr [0x62383a]                  # 00477dda
    test edx, edx                                # 00477de0
    je.d8 L_00477e63                             # 00477de2
    # block 0x00477de4: entered by fall-through of je at 0x00477de2, 31 instruction(s), calls FUN_004c5377, ends with forward jump to 0x00477ee8
    mov eax, dword ptr [ebp - local_4]           # 00477de4
    mov ecx, dword ptr [eax + field_67c]         # 00477de7
    add ecx, dword ptr [0x58318a]                # 00477ded
    mov dword ptr [ebp - local_3c], ecx          # 00477df3
    mov edx, dword ptr [ebp - local_4]           # 00477df6
    mov eax, dword ptr [edx + field_684]         # 00477df9
    add eax, dword ptr [0x58318a]                # 00477dff
    mov dword ptr [ebp - local_34], eax          # 00477e05
    mov ecx, dword ptr [ebp - local_4]           # 00477e08
    mov edx, dword ptr [ecx + field_678]         # 00477e0b
    add edx, dword ptr [0x583186]                # 00477e11
    mov dword ptr [ebp - local_40], edx          # 00477e17
    mov eax, dword ptr [ebp - local_4]           # 00477e1a
    mov ecx, dword ptr [eax + field_680]         # 00477e1d
    add ecx, dword ptr [0x583186]                # 00477e23
    mov dword ptr [ebp - local_38], ecx          # 00477e29
    push 0x54ca88                                # 00477e2c
    lea edx, [ebp - local_40]                    # 00477e31
    push edx                                     # 00477e34
    mov eax, dword ptr [ebp - local_4]           # 00477e35
    add eax, 0x48                                # 00477e38
    push eax                                     # 00477e3b
    mov ecx, dword ptr [0x5cf665]                # 00477e3c
    push ecx                                     # 00477e42
    movsx edx, word ptr [0x622fc2]               # 00477e43
    imul edx, edx, 0x4a                          # 00477e4a
    mov eax, dword ptr [edx + 0x5d1599]          # 00477e4d
    push eax                                     # 00477e53
    mov ecx, 0x5cf659                            # 00477e54
    call FUN_004c5377                            # 00477e59
    jmp.d32 L_00477ee8                           # 00477e5e
L_00477e63:
    # block 0x00477e63: entered by je at 0x00477de2, 4 instruction(s), ends with je to 0x00477ee8 (forward)
    {load} xor ecx, ecx                          # 00477e63
    mov cl, byte ptr [0x62383b]                  # 00477e65
    test ecx, ecx                                # 00477e6b
    je.d8 L_00477ee8                             # 00477e6d
    # block 0x00477e6f: entered by fall-through of je at 0x00477e6d, 29 instruction(s), calls FUN_004c5377, falls into the block at 0x00477ee8
    mov edx, dword ptr [ebp - local_4]           # 00477e6f
    mov eax, dword ptr [edx + field_67c]         # 00477e72
    add eax, dword ptr [0x58318a]                # 00477e78
    mov dword ptr [ebp - local_3c], eax          # 00477e7e
    mov ecx, dword ptr [ebp - local_4]           # 00477e81
    mov edx, dword ptr [ecx + field_684]         # 00477e84
    add edx, dword ptr [0x58318a]                # 00477e8a
    mov dword ptr [ebp - local_34], edx          # 00477e90
    mov eax, dword ptr [ebp - local_4]           # 00477e93
    mov ecx, dword ptr [eax + field_678]         # 00477e96
    add ecx, dword ptr [0x583186]                # 00477e9c
    mov dword ptr [ebp - local_40], ecx          # 00477ea2
    mov edx, dword ptr [ebp - local_4]           # 00477ea5
    mov eax, dword ptr [edx + field_680]         # 00477ea8
    add eax, dword ptr [0x583186]                # 00477eae
    mov dword ptr [ebp - local_38], eax          # 00477eb4
    push 0x54caa8                                # 00477eb7
    lea ecx, [ebp - local_40]                    # 00477ebc
    push ecx                                     # 00477ebf
    mov edx, dword ptr [ebp - local_4]           # 00477ec0
    add edx, 0x678                               # 00477ec3
    push edx                                     # 00477ec9
    mov eax, dword ptr [0x5cf665]                # 00477eca
    push eax                                     # 00477ecf
    mov ecx, dword ptr [0x5d15e3]                # 00477ed0
    push ecx                                     # 00477ed6
    mov ecx, 0x5cf659                            # 00477ed7
    call FUN_004c5377                            # 00477edc
    mov byte ptr [0x62383b], 0x0                 # 00477ee1
L_00477ee8:
    # block 0x00477ee8: entered by jmp at 0x00477e5e; je at 0x00477e6d, 7 instruction(s), ends with je to 0x00477f1e (forward)
    mov edi, 0x63a890                            # 00477ee8
    mov esi, dword ptr [ebp - local_4]           # 00477eed
    add esi, 0x23e                               # 00477ef0
    mov ecx, 0x1                                 # 00477ef6
    {load} xor edx, edx                          # 00477efb
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00477efd
    je.d8 L_00477f1e                             # 00477eff
    # block 0x00477f01: entered by fall-through of je at 0x00477eff, 8 instruction(s), calls FUN_00475cc4, falls into the block at 0x00477f1e
    mov eax, dword ptr [ebp - local_4]           # 00477f01
    add eax, 0x668                               # 00477f04
    push eax                                     # 00477f09
    mov ecx, dword ptr [ebp - local_4]           # 00477f0a
    add ecx, 0x23e                               # 00477f0d
    push ecx                                     # 00477f13
    mov ecx, 0x622fa2                            # 00477f14
    call FUN_00475cc4                            # 00477f19
L_00477f1e:
    # block 0x00477f1e: entered by je at 0x00477eff, 6 instruction(s), ends with je to 0x00477f4b (forward)
    mov edi, 0x63a894                            # 00477f1e
    mov esi, 0x623819                            # 00477f23
    mov ecx, 0x1                                 # 00477f28
    {load} xor edx, edx                          # 00477f2d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00477f2f
    je.d8 L_00477f4b                             # 00477f31
    # block 0x00477f33: entered by fall-through of je at 0x00477f31, 6 instruction(s), calls FUN_00475cc4, falls into the block at 0x00477f4b
    mov eax, dword ptr [ebp - local_4]           # 00477f33
    add eax, 0x688                               # 00477f36
    push eax                                     # 00477f3b
    push 0x623819                                # 00477f3c
    mov ecx, 0x622fa2                            # 00477f41
    call FUN_00475cc4                            # 00477f46
L_00477f4b:
    # block 0x00477f4b: entered by je at 0x00477f31, 1 instruction(s), ends with forward jump to 0x004780cc
    jmp.d32 L_004780cc                           # 00477f4b
L_00477f50:
    # block 0x00477f50: entered by je at 0x0047793d, 4 instruction(s), ends with jle to 0x004780cc (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00477f50
    movsx edx, word ptr [ecx + field_63e]        # 00477f53
    test edx, edx                                # 00477f5a
    jle.d32 L_004780cc                           # 00477f5c
    # block 0x00477f62: entered by fall-through of jle at 0x00477f5c, 71 instruction(s), calls FUN_004c5377, FUN_004d3836, FUN_0050ca3e, FUN_00475cc4, ends with forward jump to 0x00478080
    push 0x54cac8                                # 00477f62
    push 0x583186                                # 00477f67
    push 0x583196                                # 00477f6c
    mov eax, dword ptr [0x5cf665]                # 00477f71
    push eax                                     # 00477f76
    mov ecx, dword ptr [0x622fca]                # 00477f77
    push ecx                                     # 00477f7d
    mov ecx, 0x5cf659                            # 00477f7e
    call FUN_004c5377                            # 00477f83
    mov edx, dword ptr [ebp - local_4]           # 00477f88
    movsx eax, word ptr [edx + field_23a]        # 00477f8b
    imul eax, eax, 0x1d0                         # 00477f92
    add eax, 0x5adb3a                            # 00477f98
    push eax                                     # 00477f9d
    mov ecx, dword ptr [ebp - local_4]           # 00477f9e
    movsx edx, word ptr [ecx + field_23a]        # 00477fa1
    imul edx, edx, 0x7f3                         # 00477fa8
    add edx, 0x5a4c24                            # 00477fae
    push edx                                     # 00477fb4
    push 0x54caf0                                # 00477fb5
    call FUN_004d3836                            # 00477fba
    add esp, 0xc                                 # 00477fbf
    movsx eax, ax                                # 00477fc2
    add eax, 0xd                                 # 00477fc5
    mov word ptr [ebp - local_48], ax            # 00477fc8
    mov ecx, dword ptr [ebp - local_4]           # 00477fcc
    mov edx, dword ptr [ecx + field_6dc]         # 00477fcf
    mov eax, dword ptr [0x58318a]                # 00477fd5
    lea ecx, [edx + eax - field_minus_6]         # 00477fda
    mov dword ptr [ebp - local_3c], ecx          # 00477fde
    movsx edx, word ptr [ebp - local_48]         # 00477fe1
    mov eax, dword ptr [ebp - local_3c]          # 00477fe5
    {load} add eax, edx                          # 00477fe8
    mov dword ptr [ebp - local_34], eax          # 00477fea
    mov ecx, dword ptr [ebp - local_4]           # 00477fed
    mov edx, dword ptr [ecx + field_6d8]         # 00477ff0
    add edx, dword ptr [0x583186]                # 00477ff6
    mov dword ptr [ebp - local_40], edx          # 00477ffc
    mov eax, dword ptr [ebp - local_40]          # 00477fff
    add eax, 0x64                                # 00478002
    mov dword ptr [ebp - local_38], eax          # 00478005
    push 0x6237d7                                # 00478008
    push 0x54caf4                                # 0047800d
    lea ecx, [ebp - local_30]                    # 00478012
    push ecx                                     # 00478015
    call FUN_0050ca3e                            # 00478016
    add esp, 0xc                                 # 0047801b
    lea edx, [ebp - local_40]                    # 0047801e
    push edx                                     # 00478021
    lea eax, [ebp - local_30]                    # 00478022
    push eax                                     # 00478025
    mov ecx, 0x622fa2                            # 00478026
    call FUN_00475cc4                            # 0047802b
    mov ecx, dword ptr [ebp - local_4]           # 00478030
    mov edx, dword ptr [ecx + field_6e4]         # 00478033
    mov eax, dword ptr [0x58318a]                # 00478039
    lea ecx, [edx + eax - field_minus_10]        # 0047803e
    mov dword ptr [ebp - local_3c], ecx          # 00478042
    movsx edx, word ptr [ebp - local_48]         # 00478045
    mov eax, dword ptr [ebp - local_3c]          # 00478049
    {load} add eax, edx                          # 0047804c
    mov dword ptr [ebp - local_34], eax          # 0047804e
    mov ecx, dword ptr [ebp - local_4]           # 00478051
    mov edx, dword ptr [ecx + field_6e0]         # 00478054
    add edx, dword ptr [0x583186]                # 0047805a
    mov dword ptr [ebp - local_40], edx          # 00478060
    mov eax, dword ptr [ebp - local_40]          # 00478063
    add eax, 0x50                                # 00478066
    mov dword ptr [ebp - local_38], eax          # 00478069
    mov word ptr [ebp - local_c], 0x0            # 0047806c
    jmp.d8 L_00478080                            # 00478072
L_00478074:
    # block 0x00478074: entered by jmp at 0x004780ca, 3 instruction(s), falls into the block at 0x00478080
    mov cx, word ptr [ebp - local_c]             # 00478074
    add cx, 0x1                                  # 00478078
    mov word ptr [ebp - local_c], cx             # 0047807c
L_00478080:
    # block 0x00478080: entered by jmp at 0x00478072, 3 instruction(s), ends with jge to 0x004780cc (forward)
    movsx edx, word ptr [ebp - local_c]          # 00478080
    cmp edx, 0x5                                 # 00478084
    jge.d8 L_004780cc                            # 00478087
    # block 0x00478089: entered by fall-through of jge at 0x00478087, 21 instruction(s), calls FUN_0050ca3e, FUN_00475cc4, ends with backward jump to 0x00478074
    mov eax, dword ptr [ebp - local_34]          # 00478089
    mov dword ptr [ebp - local_3c], eax          # 0047808c
    movsx ecx, word ptr [ebp - local_48]         # 0047808f
    mov edx, dword ptr [ebp - local_3c]          # 00478093
    {load} add edx, ecx                          # 00478096
    mov dword ptr [ebp - local_34], edx          # 00478098
    movsx eax, word ptr [ebp - local_c]          # 0047809b
    mov ecx, dword ptr [4*eax + 0x5a0549]        # 0047809f
    push ecx                                     # 004780a6
    push 0x54caf8                                # 004780a7
    lea edx, [ebp - local_30]                    # 004780ac
    push edx                                     # 004780af
    call FUN_0050ca3e                            # 004780b0
    add esp, 0xc                                 # 004780b5
    lea eax, [ebp - local_40]                    # 004780b8
    push eax                                     # 004780bb
    lea ecx, [ebp - local_30]                    # 004780bc
    push ecx                                     # 004780bf
    mov ecx, 0x622fa2                            # 004780c0
    call FUN_00475cc4                            # 004780c5
    jmp.d8 L_00478074                            # 004780ca
L_004780cc:
    # block 0x004780cc: entered by jmp at 0x00477f4b; jle at 0x00477f5c; jge at 0x00478087, 5 instruction(s), ends with ret
    pop edi                                      # 004780cc
    pop esi                                      # 004780cd
    {load} mov esp, ebp                          # 004780ce
    pop ebp                                      # 004780d0
    ret                                          # 004780d1

# --- data items (not part of the function) -------------------------
.org 0x004780d2 - 0x401000
PAD_004780d2:  # 14 byte(s) of int3 padding
    .fill 14, 1, 0xcc

