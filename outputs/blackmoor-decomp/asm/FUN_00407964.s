# FUN_00407964
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407964
# extent:       0x00407964-0x004079ab (71 code bytes)
# span:         0x00407964-0x004079ab (code 71, tables 0, padding 0)
# sha256:       3a5f9fd5a952ca4e4ad76ac690146c4c497f6fe0f0897c6422d04265325ff500
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m407964_toggle_5e360a
# naming:       native port src/original_methods_fl37.c:m407964_toggle_5e360a (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e360a; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x40 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m407964_toggle_5e360a (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00407964 - 0x401000
.globl FUN_00407964
FUN_00407964:
    # block 0x00407964: entry, 6 instruction(s), ends with jne to 0x00407980 (forward)
    push ebp                                     # 00407964
    {load} mov ebp, esp                          # 00407965
    push ecx                                     # 00407967
    mov dword ptr [ebp - local_4], ecx           # 00407968
    cmp dword ptr [0x5e360a], 0x1                # 0040796b
    jne.d8 L_00407980                            # 00407972
    # block 0x00407974: entered by fall-through of jne at 0x00407972, 2 instruction(s), ends with forward jump to 0x0040799f
    mov dword ptr [0x5e360a], 0x0                # 00407974
    jmp.d8 L_0040799f                            # 0040797e
L_00407980:
    # block 0x00407980: entered by jne at 0x00407972, 4 instruction(s), ends with jne to 0x0040799f (forward)
    mov dword ptr [0x5e360a], 0x1                # 00407980
    movsx eax, word ptr [0x5e335e]               # 0040798a
    cmp eax, 0x40                                # 00407991
    jne.d8 L_0040799f                            # 00407994
    # block 0x00407996: entered by fall-through of jne at 0x00407994, 1 instruction(s), falls into the block at 0x0040799f
    mov word ptr [0x5e335e], 0xffff              # 00407996
L_0040799f:
    # block 0x0040799f: entered by jmp at 0x0040797e; jne at 0x00407994, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0040799f
    call FUN_00404be1                            # 004079a2
    {load} mov esp, ebp                          # 004079a7
    pop ebp                                      # 004079a9
    ret                                          # 004079aa

