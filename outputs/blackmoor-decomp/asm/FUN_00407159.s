# FUN_00407159
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407159
# extent:       0x00407159-0x004071a0 (71 code bytes)
# span:         0x00407159-0x004071a0 (code 71, tables 0, padding 0)
# sha256:       9448bf2098deb7d0347f81ec7f5546a9157b1a35b2b2fa83d1b2d177265324fa
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m407159_toggle_5e3596
# naming:       native port src/original_methods_fl37.c:m407159_toggle_5e3596 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e3596; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x23 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m407159_toggle_5e3596 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00407159 - 0x401000
.globl FUN_00407159
FUN_00407159:
    # block 0x00407159: entry, 6 instruction(s), ends with jne to 0x00407175 (forward)
    push ebp                                     # 00407159
    {load} mov ebp, esp                          # 0040715a
    push ecx                                     # 0040715c
    mov dword ptr [ebp - local_4], ecx           # 0040715d
    cmp dword ptr [0x5e3596], 0x1                # 00407160
    jne.d8 L_00407175                            # 00407167
    # block 0x00407169: entered by fall-through of jne at 0x00407167, 2 instruction(s), ends with forward jump to 0x00407194
    mov dword ptr [0x5e3596], 0x0                # 00407169
    jmp.d8 L_00407194                            # 00407173
L_00407175:
    # block 0x00407175: entered by jne at 0x00407167, 4 instruction(s), ends with jne to 0x00407194 (forward)
    mov dword ptr [0x5e3596], 0x1                # 00407175
    movsx eax, word ptr [0x5e335e]               # 0040717f
    cmp eax, 0x23                                # 00407186
    jne.d8 L_00407194                            # 00407189
    # block 0x0040718b: entered by fall-through of jne at 0x00407189, 1 instruction(s), falls into the block at 0x00407194
    mov word ptr [0x5e335e], 0xffff              # 0040718b
L_00407194:
    # block 0x00407194: entered by jmp at 0x00407173; jne at 0x00407189, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00407194
    call FUN_00404be1                            # 00407197
    {load} mov esp, ebp                          # 0040719c
    pop ebp                                      # 0040719e
    ret                                          # 0040719f

