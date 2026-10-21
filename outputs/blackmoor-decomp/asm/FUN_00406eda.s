# FUN_00406eda
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406eda
# extent:       0x00406eda-0x00406f21 (71 code bytes)
# span:         0x00406eda-0x00406f21 (code 71, tables 0, padding 0)
# sha256:       b95c6ce6f7b99c78835649794b8b84167fa210eed175cd2023e6b1825d24d75a
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m406eda_toggle_5e3572
# naming:       native port src/original_methods_fl37.c:m406eda_toggle_5e3572 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e3572; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x1a becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m406eda_toggle_5e3572 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00406eda - 0x401000
.globl FUN_00406eda
FUN_00406eda:
    # block 0x00406eda: entry, 6 instruction(s), ends with jne to 0x00406ef6 (forward)
    push ebp                                     # 00406eda
    {load} mov ebp, esp                          # 00406edb
    push ecx                                     # 00406edd
    mov dword ptr [ebp - local_4], ecx           # 00406ede
    cmp dword ptr [0x5e3572], 0x1                # 00406ee1
    jne.d8 L_00406ef6                            # 00406ee8
    # block 0x00406eea: entered by fall-through of jne at 0x00406ee8, 2 instruction(s), ends with forward jump to 0x00406f15
    mov dword ptr [0x5e3572], 0x0                # 00406eea
    jmp.d8 L_00406f15                            # 00406ef4
L_00406ef6:
    # block 0x00406ef6: entered by jne at 0x00406ee8, 4 instruction(s), ends with jne to 0x00406f15 (forward)
    mov dword ptr [0x5e3572], 0x1                # 00406ef6
    movsx eax, word ptr [0x5e335e]               # 00406f00
    cmp eax, 0x1a                                # 00406f07
    jne.d8 L_00406f15                            # 00406f0a
    # block 0x00406f0c: entered by fall-through of jne at 0x00406f0a, 1 instruction(s), falls into the block at 0x00406f15
    mov word ptr [0x5e335e], 0xffff              # 00406f0c
L_00406f15:
    # block 0x00406f15: entered by jmp at 0x00406ef4; jne at 0x00406f0a, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406f15
    call FUN_00404be1                            # 00406f18
    {load} mov esp, ebp                          # 00406f1d
    pop ebp                                      # 00406f1f
    ret                                          # 00406f20

