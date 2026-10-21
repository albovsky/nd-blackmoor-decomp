# FUN_004073d8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004073d8
# extent:       0x004073d8-0x0040741f (71 code bytes)
# span:         0x004073d8-0x0040741f (code 71, tables 0, padding 0)
# sha256:       dfd7a6b0fc6070763d78ec17c7549ce6fc86c16440d04d037f0e72c55e8b43a0
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4073d8_toggle_5e35ba
# naming:       native port src/original_methods_fl37.c:m4073d8_toggle_5e35ba (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e35ba; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x2c becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m4073d8_toggle_5e35ba (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x004073d8 - 0x401000
.globl FUN_004073d8
FUN_004073d8:
    # block 0x004073d8: entry, 6 instruction(s), ends with jne to 0x004073f4 (forward)
    push ebp                                     # 004073d8
    {load} mov ebp, esp                          # 004073d9
    push ecx                                     # 004073db
    mov dword ptr [ebp - local_4], ecx           # 004073dc
    cmp dword ptr [0x5e35ba], 0x1                # 004073df
    jne.d8 L_004073f4                            # 004073e6
    # block 0x004073e8: entered by fall-through of jne at 0x004073e6, 2 instruction(s), ends with forward jump to 0x00407413
    mov dword ptr [0x5e35ba], 0x0                # 004073e8
    jmp.d8 L_00407413                            # 004073f2
L_004073f4:
    # block 0x004073f4: entered by jne at 0x004073e6, 4 instruction(s), ends with jne to 0x00407413 (forward)
    mov dword ptr [0x5e35ba], 0x1                # 004073f4
    movsx eax, word ptr [0x5e335e]               # 004073fe
    cmp eax, 0x2c                                # 00407405
    jne.d8 L_00407413                            # 00407408
    # block 0x0040740a: entered by fall-through of jne at 0x00407408, 1 instruction(s), falls into the block at 0x00407413
    mov word ptr [0x5e335e], 0xffff              # 0040740a
L_00407413:
    # block 0x00407413: entered by jmp at 0x004073f2; jne at 0x00407408, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00407413
    call FUN_00404be1                            # 00407416
    {load} mov esp, ebp                          # 0040741b
    pop ebp                                      # 0040741d
    ret                                          # 0040741e

