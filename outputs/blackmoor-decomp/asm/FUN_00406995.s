# FUN_00406995
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406995
# extent:       0x00406995-0x004069dc (71 code bytes)
# span:         0x00406995-0x004069dc (code 71, tables 0, padding 0)
# sha256:       5e12ec120fed91fcad6a8c1ea5ad4639022c0272952cafb344630789b7f47cef
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m406995_toggle_5e3526
# naming:       native port src/original_methods_fl34b.c:m406995_toggle_5e3526 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e3526; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x7 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl34b.c:m406995_toggle_5e3526 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00406995 - 0x401000
.globl FUN_00406995
FUN_00406995:
    # block 0x00406995: entry, 6 instruction(s), ends with jne to 0x004069b1 (forward)
    push ebp                                     # 00406995
    {load} mov ebp, esp                          # 00406996
    push ecx                                     # 00406998
    mov dword ptr [ebp - local_4], ecx           # 00406999
    cmp dword ptr [0x5e3526], 0x1                # 0040699c
    jne.d8 L_004069b1                            # 004069a3
    # block 0x004069a5: entered by fall-through of jne at 0x004069a3, 2 instruction(s), ends with forward jump to 0x004069d0
    mov dword ptr [0x5e3526], 0x0                # 004069a5
    jmp.d8 L_004069d0                            # 004069af
L_004069b1:
    # block 0x004069b1: entered by jne at 0x004069a3, 4 instruction(s), ends with jne to 0x004069d0 (forward)
    mov dword ptr [0x5e3526], 0x1                # 004069b1
    movsx eax, word ptr [0x5e335e]               # 004069bb
    cmp eax, 0x7                                 # 004069c2
    jne.d8 L_004069d0                            # 004069c5
    # block 0x004069c7: entered by fall-through of jne at 0x004069c5, 1 instruction(s), falls into the block at 0x004069d0
    mov word ptr [0x5e335e], 0xffff              # 004069c7
L_004069d0:
    # block 0x004069d0: entered by jmp at 0x004069af; jne at 0x004069c5, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004069d0
    call FUN_00404be1                            # 004069d3
    {load} mov esp, ebp                          # 004069d8
    pop ebp                                      # 004069da
    ret                                          # 004069db

