# FUN_00406f68
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406f68
# extent:       0x00406f68-0x00406faf (71 code bytes)
# span:         0x00406f68-0x00406faf (code 71, tables 0, padding 0)
# sha256:       e58b135b68f256d604db0164df49df3639bf6d53f6ffe292abc2afd784a9945f
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m406f68_toggle_5e357a
# naming:       native port src/original_methods_fl37.c:m406f68_toggle_5e357a (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e357a; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x1c becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m406f68_toggle_5e357a (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00406f68 - 0x401000
.globl FUN_00406f68
FUN_00406f68:
    # block 0x00406f68: entry, 6 instruction(s), ends with jne to 0x00406f84 (forward)
    push ebp                                     # 00406f68
    {load} mov ebp, esp                          # 00406f69
    push ecx                                     # 00406f6b
    mov dword ptr [ebp - local_4], ecx           # 00406f6c
    cmp dword ptr [0x5e357a], 0x1                # 00406f6f
    jne.d8 L_00406f84                            # 00406f76
    # block 0x00406f78: entered by fall-through of jne at 0x00406f76, 2 instruction(s), ends with forward jump to 0x00406fa3
    mov dword ptr [0x5e357a], 0x0                # 00406f78
    jmp.d8 L_00406fa3                            # 00406f82
L_00406f84:
    # block 0x00406f84: entered by jne at 0x00406f76, 4 instruction(s), ends with jne to 0x00406fa3 (forward)
    mov dword ptr [0x5e357a], 0x1                # 00406f84
    movsx eax, word ptr [0x5e335e]               # 00406f8e
    cmp eax, 0x1c                                # 00406f95
    jne.d8 L_00406fa3                            # 00406f98
    # block 0x00406f9a: entered by fall-through of jne at 0x00406f98, 1 instruction(s), falls into the block at 0x00406fa3
    mov word ptr [0x5e335e], 0xffff              # 00406f9a
L_00406fa3:
    # block 0x00406fa3: entered by jmp at 0x00406f82; jne at 0x00406f98, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406fa3
    call FUN_00404be1                            # 00406fa6
    {load} mov esp, ebp                          # 00406fab
    pop ebp                                      # 00406fad
    ret                                          # 00406fae

