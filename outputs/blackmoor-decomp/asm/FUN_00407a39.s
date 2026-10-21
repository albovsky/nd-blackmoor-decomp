# FUN_00407a39
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407a39
# extent:       0x00407a39-0x00407a80 (71 code bytes)
# span:         0x00407a39-0x00407a80 (code 71, tables 0, padding 0)
# sha256:       3989660f8e6c3177185fdd38d91f19cd4ed57655f323a7bec4035491d5c619c1
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m407a39_toggle_5e3616
# naming:       native port src/original_methods_fl37.c:m407a39_toggle_5e3616 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e3616; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x43 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m407a39_toggle_5e3616 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00407a39 - 0x401000
.globl FUN_00407a39
FUN_00407a39:
    # block 0x00407a39: entry, 6 instruction(s), ends with jne to 0x00407a55 (forward)
    push ebp                                     # 00407a39
    {load} mov ebp, esp                          # 00407a3a
    push ecx                                     # 00407a3c
    mov dword ptr [ebp - local_4], ecx           # 00407a3d
    cmp dword ptr [0x5e3616], 0x1                # 00407a40
    jne.d8 L_00407a55                            # 00407a47
    # block 0x00407a49: entered by fall-through of jne at 0x00407a47, 2 instruction(s), ends with forward jump to 0x00407a74
    mov dword ptr [0x5e3616], 0x0                # 00407a49
    jmp.d8 L_00407a74                            # 00407a53
L_00407a55:
    # block 0x00407a55: entered by jne at 0x00407a47, 4 instruction(s), ends with jne to 0x00407a74 (forward)
    mov dword ptr [0x5e3616], 0x1                # 00407a55
    movsx eax, word ptr [0x5e335e]               # 00407a5f
    cmp eax, 0x43                                # 00407a66
    jne.d8 L_00407a74                            # 00407a69
    # block 0x00407a6b: entered by fall-through of jne at 0x00407a69, 1 instruction(s), falls into the block at 0x00407a74
    mov word ptr [0x5e335e], 0xffff              # 00407a6b
L_00407a74:
    # block 0x00407a74: entered by jmp at 0x00407a53; jne at 0x00407a69, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00407a74
    call FUN_00404be1                            # 00407a77
    {load} mov esp, ebp                          # 00407a7c
    pop ebp                                      # 00407a7e
    ret                                          # 00407a7f

