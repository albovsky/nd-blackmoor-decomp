# FUN_00407084
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407084
# extent:       0x00407084-0x004070cb (71 code bytes)
# span:         0x00407084-0x004070cb (code 71, tables 0, padding 0)
# sha256:       6055b422c3e2fb9789c0dce8fbc140b18377919854c45c4e2fe62ed051d20fb7
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m407084_toggle_5e358a
# naming:       native port src/original_methods_fl37.c:m407084_toggle_5e358a (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e358a; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x20 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m407084_toggle_5e358a (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00407084 - 0x401000
.globl FUN_00407084
FUN_00407084:
    # block 0x00407084: entry, 6 instruction(s), ends with jne to 0x004070a0 (forward)
    push ebp                                     # 00407084
    {load} mov ebp, esp                          # 00407085
    push ecx                                     # 00407087
    mov dword ptr [ebp - local_4], ecx           # 00407088
    cmp dword ptr [0x5e358a], 0x1                # 0040708b
    jne.d8 L_004070a0                            # 00407092
    # block 0x00407094: entered by fall-through of jne at 0x00407092, 2 instruction(s), ends with forward jump to 0x004070bf
    mov dword ptr [0x5e358a], 0x0                # 00407094
    jmp.d8 L_004070bf                            # 0040709e
L_004070a0:
    # block 0x004070a0: entered by jne at 0x00407092, 4 instruction(s), ends with jne to 0x004070bf (forward)
    mov dword ptr [0x5e358a], 0x1                # 004070a0
    movsx eax, word ptr [0x5e335e]               # 004070aa
    cmp eax, 0x20                                # 004070b1
    jne.d8 L_004070bf                            # 004070b4
    # block 0x004070b6: entered by fall-through of jne at 0x004070b4, 1 instruction(s), falls into the block at 0x004070bf
    mov word ptr [0x5e335e], 0xffff              # 004070b6
L_004070bf:
    # block 0x004070bf: entered by jmp at 0x0040709e; jne at 0x004070b4, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004070bf
    call FUN_00404be1                            # 004070c2
    {load} mov esp, ebp                          # 004070c7
    pop ebp                                      # 004070c9
    ret                                          # 004070ca

