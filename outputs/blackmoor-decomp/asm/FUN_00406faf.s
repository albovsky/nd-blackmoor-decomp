# FUN_00406faf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406faf
# extent:       0x00406faf-0x00406ff6 (71 code bytes)
# span:         0x00406faf-0x00406ff6 (code 71, tables 0, padding 0)
# sha256:       f61fdd478fa0c2fe7853c1c8eeebe92fb0bb14745d8f2e7468c52327ba65073c
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m406faf_toggle_5e357e
# naming:       native port src/original_methods_fl37.c:m406faf_toggle_5e357e (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e357e; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x1d becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m406faf_toggle_5e357e (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00406faf - 0x401000
.globl FUN_00406faf
FUN_00406faf:
    # block 0x00406faf: entry, 6 instruction(s), ends with jne to 0x00406fcb (forward)
    push ebp                                     # 00406faf
    {load} mov ebp, esp                          # 00406fb0
    push ecx                                     # 00406fb2
    mov dword ptr [ebp - local_4], ecx           # 00406fb3
    cmp dword ptr [0x5e357e], 0x1                # 00406fb6
    jne.d8 L_00406fcb                            # 00406fbd
    # block 0x00406fbf: entered by fall-through of jne at 0x00406fbd, 2 instruction(s), ends with forward jump to 0x00406fea
    mov dword ptr [0x5e357e], 0x0                # 00406fbf
    jmp.d8 L_00406fea                            # 00406fc9
L_00406fcb:
    # block 0x00406fcb: entered by jne at 0x00406fbd, 4 instruction(s), ends with jne to 0x00406fea (forward)
    mov dword ptr [0x5e357e], 0x1                # 00406fcb
    movsx eax, word ptr [0x5e335e]               # 00406fd5
    cmp eax, 0x1d                                # 00406fdc
    jne.d8 L_00406fea                            # 00406fdf
    # block 0x00406fe1: entered by fall-through of jne at 0x00406fdf, 1 instruction(s), falls into the block at 0x00406fea
    mov word ptr [0x5e335e], 0xffff              # 00406fe1
L_00406fea:
    # block 0x00406fea: entered by jmp at 0x00406fc9; jne at 0x00406fdf, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406fea
    call FUN_00404be1                            # 00406fed
    {load} mov esp, ebp                          # 00406ff2
    pop ebp                                      # 00406ff4
    ret                                          # 00406ff5

