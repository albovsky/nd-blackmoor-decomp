# FUN_00406e05
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406e05
# extent:       0x00406e05-0x00406e4c (71 code bytes)
# span:         0x00406e05-0x00406e4c (code 71, tables 0, padding 0)
# sha256:       ad32360bc41771698c9b35de754a41038dd777667e436059724bef0306b3e911
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m406e05_toggle_5e3566
# naming:       native port src/original_methods_fl37.c:m406e05_toggle_5e3566 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e3566; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x17 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m406e05_toggle_5e3566 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00406e05 - 0x401000
.globl FUN_00406e05
FUN_00406e05:
    # block 0x00406e05: entry, 6 instruction(s), ends with jne to 0x00406e21 (forward)
    push ebp                                     # 00406e05
    {load} mov ebp, esp                          # 00406e06
    push ecx                                     # 00406e08
    mov dword ptr [ebp - local_4], ecx           # 00406e09
    cmp dword ptr [0x5e3566], 0x1                # 00406e0c
    jne.d8 L_00406e21                            # 00406e13
    # block 0x00406e15: entered by fall-through of jne at 0x00406e13, 2 instruction(s), ends with forward jump to 0x00406e40
    mov dword ptr [0x5e3566], 0x0                # 00406e15
    jmp.d8 L_00406e40                            # 00406e1f
L_00406e21:
    # block 0x00406e21: entered by jne at 0x00406e13, 4 instruction(s), ends with jne to 0x00406e40 (forward)
    mov dword ptr [0x5e3566], 0x1                # 00406e21
    movsx eax, word ptr [0x5e335e]               # 00406e2b
    cmp eax, 0x17                                # 00406e32
    jne.d8 L_00406e40                            # 00406e35
    # block 0x00406e37: entered by fall-through of jne at 0x00406e35, 1 instruction(s), falls into the block at 0x00406e40
    mov word ptr [0x5e335e], 0xffff              # 00406e37
L_00406e40:
    # block 0x00406e40: entered by jmp at 0x00406e1f; jne at 0x00406e35, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406e40
    call FUN_00404be1                            # 00406e43
    {load} mov esp, ebp                          # 00406e48
    pop ebp                                      # 00406e4a
    ret                                          # 00406e4b

