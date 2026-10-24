# FUN_004dbcd0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dbcd0
# extent:       0x004dbcd0-0x004dbe99 (457 code bytes)
# span:         0x004dbcd0-0x004dbea0 (code 457, tables 0, padding 7)
# sha256:       cdbb8cdc19caa239baf318348ee46e9882e7653bb931aa1450d04f2517963602
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4dbcd0_lifted
# naming:       native port src/original_methods_fl41.c:m4dbcd0_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 23 seeds; oracle: 102/102 instructions, 16/16 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [edx + n] field_minus_1
# callees:      calls FUN_0044a2b7, FUN_004dad60, FUN_004c2790, FUN_004faf98, KERNEL32.dll!GetTickCount, FUN_004c5377, FUN_004dadff, FUN_004c2dfb
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4dbcd0_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 102 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
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

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004dadff, .text + (0x004dadff - 0x401000)
.set FUN_004faf98, .text + (0x004faf98 - 0x401000)

.org 0x004dbcd0 - 0x401000
.globl FUN_004dbcd0
FUN_004dbcd0:
    # block 0x004dbcd0: entry, 7 instruction(s), ends with je to 0x004dbcfd (forward)
    push ebp                                     # 004dbcd0
    {load} mov ebp, esp                          # 004dbcd1
    sub esp, 0x28                                # 004dbcd3
    mov eax, dword ptr [0x58398d]                # 004dbcd6
    mov dword ptr [ebp - local_28], eax          # 004dbcdb
    cmp dword ptr [ebp - local_28], 0x0          # 004dbcde
    je.d8 L_004dbcfd                             # 004dbce2
    # block 0x004dbce4: entered by fall-through of je at 0x004dbce2, 2 instruction(s), ends with je to 0x004dbda6 (forward)
    cmp dword ptr [ebp - local_28], 0x1          # 004dbce4
    je.d32 L_004dbda6                            # 004dbce8
    # block 0x004dbcee: entered by fall-through of je at 0x004dbce8, 2 instruction(s), ends with je to 0x004dbe68 (forward)
    cmp dword ptr [ebp - local_28], 0x2          # 004dbcee
    je.d32 L_004dbe68                            # 004dbcf2
    # block 0x004dbcf8: entered by fall-through of je at 0x004dbcf2, 1 instruction(s), ends with forward jump to 0x004dbe95
    jmp.d32 L_004dbe95                           # 004dbcf8
L_004dbcfd:
    # block 0x004dbcfd: entered by je at 0x004dbce2, 3 instruction(s), ends with je to 0x004dbd15 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004dbcfd
    test ecx, ecx                                # 004dbd04
    je.d8 L_004dbd15                             # 004dbd06
    # block 0x004dbd08: entered by fall-through of je at 0x004dbd06, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004dbd15
    push 0x55afe0                                # 004dbd08
    call FUN_0044a2b7                            # 004dbd0d
    add esp, 0x4                                 # 004dbd12
L_004dbd15:
    # block 0x004dbd15: entered by je at 0x004dbd06, 11 instruction(s), calls FUN_004dad60, FUN_004c2790, ends with je to 0x004dbd8c (forward)
    mov ecx, 0x5830a6                            # 004dbd15
    call FUN_004dad60                            # 004dbd1a
    push 0x55b00c                                # 004dbd1f
    push 0x6                                     # 004dbd24
    push 0x5b0685                                # 004dbd26
    push 0x55b024                                # 004dbd2b
    mov ecx, 0x5cf659                            # 004dbd30
    call FUN_004c2790                            # 004dbd35
    mov dword ptr [0x5d032b], eax                # 004dbd3a
    cmp dword ptr [0x5bb21a], 0x0                # 004dbd3f
    je.d8 L_004dbd8c                             # 004dbd46
    # block 0x004dbd48: entered by fall-through of je at 0x004dbd46, 9 instruction(s), ends with jne to 0x004dbd82 (forward)
    mov dx, word ptr [0x5b451f]                  # 004dbd48
    mov word ptr [ebp - local_14], dx            # 004dbd4f
    mov eax, dword ptr [ebp - local_14]          # 004dbd53
    and eax, 0xffff                              # 004dbd56
    imul eax, eax, 0x5bb                         # 004dbd5b
    {load} xor ecx, ecx                          # 004dbd61
    mov cx, word ptr [eax + 0x5c3b99]            # 004dbd63
    test ecx, ecx                                # 004dbd6a
    jne.d8 L_004dbd82                            # 004dbd6c
    # block 0x004dbd6e: entered by fall-through of jne at 0x004dbd6c, 5 instruction(s), calls FUN_004faf98, falls into the block at 0x004dbd82
    mov dx, word ptr [ebp - local_14]            # 004dbd6e
    push edx                                     # 004dbd72
    push 0x5b452d                                # 004dbd73
    mov ecx, 0x5c3a67                            # 004dbd78
    call FUN_004faf98                            # 004dbd7d
L_004dbd82:
    # block 0x004dbd82: entered by jne at 0x004dbd6c, 1 instruction(s), falls into the block at 0x004dbd8c
    mov dword ptr [0x5bb21a], 0x0                # 004dbd82
L_004dbd8c:
    # block 0x004dbd8c: entered by je at 0x004dbd46, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004dbe95
    call dword ptr [0x52a23c]                    # 004dbd8c
    mov dword ptr [0x63a9c8], eax                # 004dbd92
    mov dword ptr [0x58398d], 0x1                # 004dbd97
    jmp.d32 L_004dbe95                           # 004dbda1
L_004dbda6:
    # block 0x004dbda6: entered by je at 0x004dbce8, 37 instruction(s), calls FUN_004c5377, FUN_004dadff, KERNEL32.dll!GetTickCount, ends with ja to 0x004dbe52 (forward)
    mov dword ptr [ebp - local_c], 0x0           # 004dbda6
    mov dword ptr [ebp - local_10], 0x0          # 004dbdad
    movsx eax, word ptr [0x63988b]               # 004dbdb4
    sub eax, 0x1                                 # 004dbdbb
    mov dword ptr [ebp - local_8], eax           # 004dbdbe
    movsx ecx, word ptr [0x63988d]               # 004dbdc1
    sub ecx, 0x1                                 # 004dbdc8
    mov dword ptr [ebp - local_4], ecx           # 004dbdcb
    movsx edx, word ptr [0x639891]               # 004dbdce
    mov dword ptr [ebp - local_20], edx          # 004dbdd5
    movsx eax, word ptr [0x63988f]               # 004dbdd8
    mov dword ptr [ebp - local_24], eax          # 004dbddf
    movsx ecx, word ptr [0x63988b]               # 004dbde2
    mov edx, dword ptr [ebp - local_24]          # 004dbde9
    lea eax, [edx + ecx - field_minus_1]         # 004dbdec
    mov dword ptr [ebp - local_1c], eax          # 004dbdf0
    movsx ecx, word ptr [0x63988d]               # 004dbdf3
    mov edx, dword ptr [ebp - local_20]          # 004dbdfa
    lea eax, [edx + ecx - field_minus_1]         # 004dbdfd
    mov dword ptr [ebp - local_18], eax          # 004dbe01
    push 0x55b02c                                # 004dbe04
    lea ecx, [ebp - local_24]                    # 004dbe09
    push ecx                                     # 004dbe0c
    lea edx, [ebp - local_10]                    # 004dbe0d
    push edx                                     # 004dbe10
    mov eax, dword ptr [0x5cf661]                # 004dbe11
    push eax                                     # 004dbe16
    mov ecx, dword ptr [0x5d032b]                # 004dbe17
    push ecx                                     # 004dbe1d
    mov ecx, 0x5cf659                            # 004dbe1e
    call FUN_004c5377                            # 004dbe23
    mov ecx, 0x5830a6                            # 004dbe28
    call FUN_004dadff                            # 004dbe2d
    call dword ptr [0x52a23c]                    # 004dbe32
    sub eax, dword ptr [0x63a9c8]                # 004dbe38
    cmp eax, 0xfa0                               # 004dbe3e
    ja.d8 L_004dbe52                             # 004dbe43
    # block 0x004dbe45: entered by fall-through of ja at 0x004dbe43, 4 instruction(s), ends with jne to 0x004dbe66 (forward)
    {load} xor edx, edx                          # 004dbe45
    mov dl, byte ptr [0x58321d]                  # 004dbe47
    cmp edx, 0x1                                 # 004dbe4d
    jne.d8 L_004dbe66                            # 004dbe50
L_004dbe52:
    # block 0x004dbe52: entered by ja at 0x004dbe43; fall-through of jne at 0x004dbe50, 3 instruction(s), calls FUN_004dad60, falls into the block at 0x004dbe66
    mov ecx, 0x5830a6                            # 004dbe52
    call FUN_004dad60                            # 004dbe57
    mov dword ptr [0x58398d], 0x2                # 004dbe5c
L_004dbe66:
    # block 0x004dbe66: entered by jne at 0x004dbe50, 1 instruction(s), ends with forward jump to 0x004dbe95
    jmp.d8 L_004dbe95                            # 004dbe66
L_004dbe68:
    # block 0x004dbe68: entered by je at 0x004dbcf2, 6 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004dbe95
    push 0x5d032b                                # 004dbe68
    mov ecx, 0x5cf659                            # 004dbe6d
    call FUN_004c2dfb                            # 004dbe72
    mov dword ptr [0x583985], 0x3                # 004dbe77
    mov dword ptr [0x583981], 0x6                # 004dbe81
    mov dword ptr [0x5839a1], 0x0                # 004dbe8b
L_004dbe95:
    # block 0x004dbe95: entered by jmp at 0x004dbcf8; jmp at 0x004dbda1; jmp at 0x004dbe66, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004dbe95
    pop ebp                                      # 004dbe97
    ret                                          # 004dbe98

# --- data items (not part of the function) -------------------------
.org 0x004dbe99 - 0x401000
PAD_004dbe99:  # 7 byte(s) of int3 padding
    .fill 7, 1, 0xcc

