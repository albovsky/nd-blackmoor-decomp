# FUN_00406ca2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406ca2
# extent:       0x00406ca2-0x00406ce9 (71 code bytes)
# span:         0x00406ca2-0x00406ce9 (code 71, tables 0, padding 0)
# sha256:       33b3829d6df1ef1ad4e13d236e2cfd92b1da96538c7bb8674f237c14145b6dbb
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m406ca2_toggle_5e3552
# naming:       native port src/original_methods_fl37.c:m406ca2_toggle_5e3552 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e3552; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x12 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m406ca2_toggle_5e3552 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00406ca2 - 0x401000
.globl FUN_00406ca2
FUN_00406ca2:
    # block 0x00406ca2: entry, 6 instruction(s), ends with jne to 0x00406cbe (forward)
    push ebp                                     # 00406ca2
    {load} mov ebp, esp                          # 00406ca3
    push ecx                                     # 00406ca5
    mov dword ptr [ebp - local_4], ecx           # 00406ca6
    cmp dword ptr [0x5e3552], 0x1                # 00406ca9
    jne.d8 L_00406cbe                            # 00406cb0
    # block 0x00406cb2: entered by fall-through of jne at 0x00406cb0, 2 instruction(s), ends with forward jump to 0x00406cdd
    mov dword ptr [0x5e3552], 0x0                # 00406cb2
    jmp.d8 L_00406cdd                            # 00406cbc
L_00406cbe:
    # block 0x00406cbe: entered by jne at 0x00406cb0, 4 instruction(s), ends with jne to 0x00406cdd (forward)
    mov dword ptr [0x5e3552], 0x1                # 00406cbe
    movsx eax, word ptr [0x5e335e]               # 00406cc8
    cmp eax, 0x12                                # 00406ccf
    jne.d8 L_00406cdd                            # 00406cd2
    # block 0x00406cd4: entered by fall-through of jne at 0x00406cd2, 1 instruction(s), falls into the block at 0x00406cdd
    mov word ptr [0x5e335e], 0xffff              # 00406cd4
L_00406cdd:
    # block 0x00406cdd: entered by jmp at 0x00406cbc; jne at 0x00406cd2, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406cdd
    call FUN_00404be1                            # 00406ce0
    {load} mov esp, ebp                          # 00406ce5
    pop ebp                                      # 00406ce7
    ret                                          # 00406ce8

