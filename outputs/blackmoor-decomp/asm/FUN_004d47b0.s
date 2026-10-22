# FUN_004d47b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d47b0
# extent:       0x004d47b0-0x004d4803 (83 code bytes)
# span:         0x004d47b0-0x004d4803 (code 83, tables 0, padding 0)
# sha256:       1398753fdaf81ab2aa981e685913ca4b723d237808147d9a691a5c19666f9075
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d47b0_lifted
# naming:       native port src/original_methods_fl39d.c:m4d47b0_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (16 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004d4803, FUN_004fb2a6, FUN_004d4c24
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4d47b0_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 25 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004d4803, .text + (0x004d4803 - 0x401000)
.set FUN_004d4c24, .text + (0x004d4c24 - 0x401000)
.set FUN_004fb2a6, .text + (0x004fb2a6 - 0x401000)

.org 0x004d47b0 - 0x401000
.globl FUN_004d47b0
FUN_004d47b0:
    # block 0x004d47b0: entry, 7 instruction(s), ends with je to 0x004d47d0 (forward)
    push ebp                                     # 004d47b0
    {load} mov ebp, esp                          # 004d47b1
    push ecx                                     # 004d47b3
    mov eax, dword ptr [0x5839a5]                # 004d47b4
    mov dword ptr [ebp - local_4], eax           # 004d47b9
    cmp dword ptr [ebp - local_4], 0x0           # 004d47bc
    je.d8 L_004d47d0                             # 004d47c0
    # block 0x004d47c2: entered by fall-through of je at 0x004d47c0, 2 instruction(s), ends with je to 0x004d47d7 (forward)
    cmp dword ptr [ebp - local_4], 0x1           # 004d47c2
    je.d8 L_004d47d7                             # 004d47c6
    # block 0x004d47c8: entered by fall-through of je at 0x004d47c6, 2 instruction(s), ends with je to 0x004d47fa (forward)
    cmp dword ptr [ebp - local_4], 0x2           # 004d47c8
    je.d8 L_004d47fa                             # 004d47cc
    # block 0x004d47ce: entered by fall-through of je at 0x004d47cc, 1 instruction(s), ends with forward jump to 0x004d47ff
    jmp.d8 L_004d47ff                            # 004d47ce
L_004d47d0:
    # block 0x004d47d0: entered by je at 0x004d47c0, 2 instruction(s), calls FUN_004d4803, ends with forward jump to 0x004d47ff
    call FUN_004d4803                            # 004d47d0
    jmp.d8 L_004d47ff                            # 004d47d5
L_004d47d7:
    # block 0x004d47d7: entered by je at 0x004d47c6, 7 instruction(s), calls FUN_004fb2a6, ends with forward jump to 0x004d47ff
    mov cx, word ptr [0x5b451f]                  # 004d47d7
    push ecx                                     # 004d47de
    push 0x5b452d                                # 004d47df
    mov ecx, 0x5c3a67                            # 004d47e4
    call FUN_004fb2a6                            # 004d47e9
    mov dword ptr [0x5839a5], 0x2                # 004d47ee
    jmp.d8 L_004d47ff                            # 004d47f8
L_004d47fa:
    # block 0x004d47fa: entered by je at 0x004d47cc, 1 instruction(s), calls FUN_004d4c24, falls into the block at 0x004d47ff
    call FUN_004d4c24                            # 004d47fa
L_004d47ff:
    # block 0x004d47ff: entered by jmp at 0x004d47ce; jmp at 0x004d47d5; jmp at 0x004d47f8, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d47ff
    pop ebp                                      # 004d4801
    ret                                          # 004d4802

