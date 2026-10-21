# FUN_00406c5b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406c5b
# extent:       0x00406c5b-0x00406ca2 (71 code bytes)
# span:         0x00406c5b-0x00406ca2 (code 71, tables 0, padding 0)
# sha256:       e9b31850b06f006cb12475953e2c4fb40a0f7e31e23ffd94e758e2faa880a9b2
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m406c5b_toggle_5e354e
# naming:       native port src/original_methods_fl37.c:m406c5b_toggle_5e354e (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e354e; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x11 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m406c5b_toggle_5e354e (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00406c5b - 0x401000
.globl FUN_00406c5b
FUN_00406c5b:
    # block 0x00406c5b: entry, 6 instruction(s), ends with jne to 0x00406c77 (forward)
    push ebp                                     # 00406c5b
    {load} mov ebp, esp                          # 00406c5c
    push ecx                                     # 00406c5e
    mov dword ptr [ebp - local_4], ecx           # 00406c5f
    cmp dword ptr [0x5e354e], 0x1                # 00406c62
    jne.d8 L_00406c77                            # 00406c69
    # block 0x00406c6b: entered by fall-through of jne at 0x00406c69, 2 instruction(s), ends with forward jump to 0x00406c96
    mov dword ptr [0x5e354e], 0x0                # 00406c6b
    jmp.d8 L_00406c96                            # 00406c75
L_00406c77:
    # block 0x00406c77: entered by jne at 0x00406c69, 4 instruction(s), ends with jne to 0x00406c96 (forward)
    mov dword ptr [0x5e354e], 0x1                # 00406c77
    movsx eax, word ptr [0x5e335e]               # 00406c81
    cmp eax, 0x11                                # 00406c88
    jne.d8 L_00406c96                            # 00406c8b
    # block 0x00406c8d: entered by fall-through of jne at 0x00406c8b, 1 instruction(s), falls into the block at 0x00406c96
    mov word ptr [0x5e335e], 0xffff              # 00406c8d
L_00406c96:
    # block 0x00406c96: entered by jmp at 0x00406c75; jne at 0x00406c8b, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406c96
    call FUN_00404be1                            # 00406c99
    {load} mov esp, ebp                          # 00406c9e
    pop ebp                                      # 00406ca0
    ret                                          # 00406ca1

