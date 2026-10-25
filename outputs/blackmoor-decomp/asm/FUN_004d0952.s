# FUN_004d0952
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d0952
# extent:       0x004d0952-0x004d0abc (362 code bytes)
# span:         0x004d0952-0x004d0abc (code 362, tables 0, padding 0)
# sha256:       b14ef67abdb1abb82b4dc4b167b540777f6135b562b3e848926d8e85cda0fcf7
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d0952_lifted
# naming:       native port src/original_methods_fl41.c:m4d0952_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 5 seeds; oracle: 83/83 instructions, 4/4 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_21, field_e5, field_e9; [ecx + n] field_e1, field_ed; [edx + n] field_e1
# callees:      calls FUN_004c5377
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4d0952_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 83 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_21, 0x21  # offset +0x21
.equ field_e1, 0xe1  # offset +0xe1
.equ field_e5, 0xe5  # offset +0xe5
.equ field_e9, 0xe9  # offset +0xe9
.equ field_ed, 0xed  # offset +0xed

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004d0952 - 0x401000
.globl FUN_004d0952
FUN_004d0952:
    # block 0x004d0952: entry, 5 instruction(s), ends with forward jump to 0x004d096c
    push ebp                                     # 004d0952
    {load} mov ebp, esp                          # 004d0953
    sub esp, 0x14                                # 004d0955
    mov word ptr [ebp - local_4], 0x0            # 004d0958
    jmp.d8 L_004d096c                            # 004d095e
L_004d0960:
    # block 0x004d0960: entered by jmp at 0x004d0ab3, 3 instruction(s), falls into the block at 0x004d096c
    mov ax, word ptr [ebp - local_4]             # 004d0960
    .insn 0x66, 0x05, 0x0001{:u16}               # 004d0964
    mov word ptr [ebp - local_4], ax             # 004d0968
L_004d096c:
    # block 0x004d096c: entered by jmp at 0x004d095e, 3 instruction(s), ends with jge to 0x004d0ab8 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004d096c
    cmp ecx, 0xc                                 # 004d0970
    jge.d32 L_004d0ab8                           # 004d0973
    # block 0x004d0979: entered by fall-through of jge at 0x004d0973, 35 instruction(s), ends with je to 0x004d0a70 (forward)
    movsx edx, word ptr [0x5b51fb]               # 004d0979
    imul edx, edx, 0x8d                          # 004d0980
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d0986
    movsx ecx, word ptr [ebp - local_4]          # 004d098c
    shl ecx, 0x4                                 # 004d0990
    mov edx, dword ptr [eax + ecx + field_e5]    # 004d0993
    add edx, dword ptr [0x58318a]                # 004d099a
    mov dword ptr [ebp - local_10], edx          # 004d09a0
    movsx eax, word ptr [0x5b51fb]               # 004d09a3
    imul eax, eax, 0x8d                          # 004d09aa
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004d09b0
    movsx edx, word ptr [ebp - local_4]          # 004d09b6
    shl edx, 0x4                                 # 004d09ba
    mov eax, dword ptr [ecx + edx + field_ed]    # 004d09bd
    add eax, dword ptr [0x58318a]                # 004d09c4
    mov dword ptr [ebp - local_8], eax           # 004d09ca
    movsx ecx, word ptr [0x5b51fb]               # 004d09cd
    imul ecx, ecx, 0x8d                          # 004d09d4
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004d09da
    movsx eax, word ptr [ebp - local_4]          # 004d09e0
    shl eax, 0x4                                 # 004d09e4
    mov ecx, dword ptr [edx + eax + field_e1]    # 004d09e7
    add ecx, dword ptr [0x583186]                # 004d09ee
    mov dword ptr [ebp - local_14], ecx          # 004d09f4
    movsx edx, word ptr [0x5b51fb]               # 004d09f7
    imul edx, edx, 0x8d                          # 004d09fe
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d0a04
    movsx ecx, word ptr [ebp - local_4]          # 004d0a0a
    shl ecx, 0x4                                 # 004d0a0e
    mov edx, dword ptr [eax + ecx + field_e9]    # 004d0a11
    add edx, dword ptr [0x583186]                # 004d0a18
    mov dword ptr [ebp - local_c], edx           # 004d0a1e
    movsx eax, word ptr [ebp - local_4]          # 004d0a21
    cmp dword ptr [4*eax + 0x5b5203], 0x0        # 004d0a25
    je.d8 L_004d0a70                             # 004d0a2d
    # block 0x004d0a2f: entered by fall-through of je at 0x004d0a2d, 17 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004d0ab3
    push 0x55a02c                                # 004d0a2f
    lea ecx, [ebp - local_14]                    # 004d0a34
    push ecx                                     # 004d0a37
    movsx edx, word ptr [0x5b51fb]               # 004d0a38
    imul edx, edx, 0x8d                          # 004d0a3f
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d0a45
    movsx ecx, word ptr [ebp - local_4]          # 004d0a4b
    shl ecx, 0x4                                 # 004d0a4f
    lea edx, [eax + ecx + field_21]              # 004d0a52
    push edx                                     # 004d0a56
    mov eax, dword ptr [0x5cf665]                # 004d0a57
    push eax                                     # 004d0a5c
    mov ecx, dword ptr [0x5d1b61]                # 004d0a5d
    push ecx                                     # 004d0a63
    mov ecx, 0x5cf659                            # 004d0a64
    call FUN_004c5377                            # 004d0a69
    jmp.d8 L_004d0ab3                            # 004d0a6e
L_004d0a70:
    # block 0x004d0a70: entered by je at 0x004d0a2d, 16 instruction(s), calls FUN_004c5377, falls into the block at 0x004d0ab3
    push 0x55a044                                # 004d0a70
    lea edx, [ebp - local_14]                    # 004d0a75
    push edx                                     # 004d0a78
    movsx eax, word ptr [0x5b51fb]               # 004d0a79
    imul eax, eax, 0x8d                          # 004d0a80
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004d0a86
    movsx edx, word ptr [ebp - local_4]          # 004d0a8c
    shl edx, 0x4                                 # 004d0a90
    lea eax, [ecx + edx + field_e1]              # 004d0a93
    push eax                                     # 004d0a9a
    mov ecx, dword ptr [0x5cf665]                # 004d0a9b
    push ecx                                     # 004d0aa1
    mov edx, dword ptr [0x5d15e3]                # 004d0aa2
    push edx                                     # 004d0aa8
    mov ecx, 0x5cf659                            # 004d0aa9
    call FUN_004c5377                            # 004d0aae
L_004d0ab3:
    # block 0x004d0ab3: entered by jmp at 0x004d0a6e, 1 instruction(s), ends with backward jump to 0x004d0960
    jmp.d32 L_004d0960                           # 004d0ab3
L_004d0ab8:
    # block 0x004d0ab8: entered by jge at 0x004d0973, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d0ab8
    pop ebp                                      # 004d0aba
    ret                                          # 004d0abb

