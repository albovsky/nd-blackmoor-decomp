# FUN_004067a5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004067a5
# extent:       0x004067a5-0x004067eb (70 code bytes)
# span:         0x004067a5-0x004067eb (code 70, tables 0, padding 0)
# sha256:       a99fbde28cf07b2027c8964b52bd49f13fe6b986dfcedcfa73b68638395f6db3
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4067a5_toggle_5e350a
# naming:       native port src/original_methods_fl34b.c:m4067a5_toggle_5e350a (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e350a; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl34b.c:m4067a5_toggle_5e350a (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x004067a5 - 0x401000
.globl FUN_004067a5
FUN_004067a5:
    # block 0x004067a5: entry, 6 instruction(s), ends with jne to 0x004067c1 (forward)
    push ebp                                     # 004067a5
    {load} mov ebp, esp                          # 004067a6
    push ecx                                     # 004067a8
    mov dword ptr [ebp - local_4], ecx           # 004067a9
    cmp dword ptr [0x5e350a], 0x1                # 004067ac
    jne.d8 L_004067c1                            # 004067b3
    # block 0x004067b5: entered by fall-through of jne at 0x004067b3, 2 instruction(s), ends with forward jump to 0x004067df
    mov dword ptr [0x5e350a], 0x0                # 004067b5
    jmp.d8 L_004067df                            # 004067bf
L_004067c1:
    # block 0x004067c1: entered by jne at 0x004067b3, 4 instruction(s), ends with jne to 0x004067df (forward)
    mov dword ptr [0x5e350a], 0x1                # 004067c1
    movsx eax, word ptr [0x5e335e]               # 004067cb
    test eax, eax                                # 004067d2
    jne.d8 L_004067df                            # 004067d4
    # block 0x004067d6: entered by fall-through of jne at 0x004067d4, 1 instruction(s), falls into the block at 0x004067df
    mov word ptr [0x5e335e], 0xffff              # 004067d6
L_004067df:
    # block 0x004067df: entered by jmp at 0x004067bf; jne at 0x004067d4, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004067df
    call FUN_00404be1                            # 004067e2
    {load} mov esp, ebp                          # 004067e7
    pop ebp                                      # 004067e9
    ret                                          # 004067ea

