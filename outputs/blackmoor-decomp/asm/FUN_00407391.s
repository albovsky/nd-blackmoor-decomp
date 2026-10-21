# FUN_00407391
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407391
# extent:       0x00407391-0x004073d8 (71 code bytes)
# span:         0x00407391-0x004073d8 (code 71, tables 0, padding 0)
# sha256:       33424d2ff9e4353dcdef72a965ac7c5d3f48cb682267725d5014565b421c2744
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m407391_toggle_5e35b6
# naming:       native port src/original_methods_fl37.c:m407391_toggle_5e35b6 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e35b6; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x2b becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m407391_toggle_5e35b6 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00407391 - 0x401000
.globl FUN_00407391
FUN_00407391:
    # block 0x00407391: entry, 6 instruction(s), ends with jne to 0x004073ad (forward)
    push ebp                                     # 00407391
    {load} mov ebp, esp                          # 00407392
    push ecx                                     # 00407394
    mov dword ptr [ebp - local_4], ecx           # 00407395
    cmp dword ptr [0x5e35b6], 0x1                # 00407398
    jne.d8 L_004073ad                            # 0040739f
    # block 0x004073a1: entered by fall-through of jne at 0x0040739f, 2 instruction(s), ends with forward jump to 0x004073cc
    mov dword ptr [0x5e35b6], 0x0                # 004073a1
    jmp.d8 L_004073cc                            # 004073ab
L_004073ad:
    # block 0x004073ad: entered by jne at 0x0040739f, 4 instruction(s), ends with jne to 0x004073cc (forward)
    mov dword ptr [0x5e35b6], 0x1                # 004073ad
    movsx eax, word ptr [0x5e335e]               # 004073b7
    cmp eax, 0x2b                                # 004073be
    jne.d8 L_004073cc                            # 004073c1
    # block 0x004073c3: entered by fall-through of jne at 0x004073c1, 1 instruction(s), falls into the block at 0x004073cc
    mov word ptr [0x5e335e], 0xffff              # 004073c3
L_004073cc:
    # block 0x004073cc: entered by jmp at 0x004073ab; jne at 0x004073c1, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004073cc
    call FUN_00404be1                            # 004073cf
    {load} mov esp, ebp                          # 004073d4
    pop ebp                                      # 004073d6
    ret                                          # 004073d7

