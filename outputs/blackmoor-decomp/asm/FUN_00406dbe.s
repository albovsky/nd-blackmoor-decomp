# FUN_00406dbe
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406dbe
# extent:       0x00406dbe-0x00406e05 (71 code bytes)
# span:         0x00406dbe-0x00406e05 (code 71, tables 0, padding 0)
# sha256:       ac996f6b0701df981d6e45d72809ee0d399373f9fce64e4401fd7a9e8b8b6030
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m406dbe_toggle_5e3562
# naming:       native port src/original_methods_fl37.c:m406dbe_toggle_5e3562 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e3562; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x16 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m406dbe_toggle_5e3562 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00406dbe - 0x401000
.globl FUN_00406dbe
FUN_00406dbe:
    # block 0x00406dbe: entry, 6 instruction(s), ends with jne to 0x00406dda (forward)
    push ebp                                     # 00406dbe
    {load} mov ebp, esp                          # 00406dbf
    push ecx                                     # 00406dc1
    mov dword ptr [ebp - local_4], ecx           # 00406dc2
    cmp dword ptr [0x5e3562], 0x1                # 00406dc5
    jne.d8 L_00406dda                            # 00406dcc
    # block 0x00406dce: entered by fall-through of jne at 0x00406dcc, 2 instruction(s), ends with forward jump to 0x00406df9
    mov dword ptr [0x5e3562], 0x0                # 00406dce
    jmp.d8 L_00406df9                            # 00406dd8
L_00406dda:
    # block 0x00406dda: entered by jne at 0x00406dcc, 4 instruction(s), ends with jne to 0x00406df9 (forward)
    mov dword ptr [0x5e3562], 0x1                # 00406dda
    movsx eax, word ptr [0x5e335e]               # 00406de4
    cmp eax, 0x16                                # 00406deb
    jne.d8 L_00406df9                            # 00406dee
    # block 0x00406df0: entered by fall-through of jne at 0x00406dee, 1 instruction(s), falls into the block at 0x00406df9
    mov word ptr [0x5e335e], 0xffff              # 00406df0
L_00406df9:
    # block 0x00406df9: entered by jmp at 0x00406dd8; jne at 0x00406dee, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406df9
    call FUN_00404be1                            # 00406dfc
    {load} mov esp, ebp                          # 00406e01
    pop ebp                                      # 00406e03
    ret                                          # 00406e04

