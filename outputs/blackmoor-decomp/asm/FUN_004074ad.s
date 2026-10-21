# FUN_004074ad
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004074ad
# extent:       0x004074ad-0x004074f4 (71 code bytes)
# span:         0x004074ad-0x004074f4 (code 71, tables 0, padding 0)
# sha256:       bf16daf7998add845a80662b108dba5b16e2accdc2305f4c6d8eba0a23e82539
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4074ad_toggle_5e35c6
# naming:       native port src/original_methods_fl37.c:m4074ad_toggle_5e35c6 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e35c6; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x2f becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m4074ad_toggle_5e35c6 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x004074ad - 0x401000
.globl FUN_004074ad
FUN_004074ad:
    # block 0x004074ad: entry, 6 instruction(s), ends with jne to 0x004074c9 (forward)
    push ebp                                     # 004074ad
    {load} mov ebp, esp                          # 004074ae
    push ecx                                     # 004074b0
    mov dword ptr [ebp - local_4], ecx           # 004074b1
    cmp dword ptr [0x5e35c6], 0x1                # 004074b4
    jne.d8 L_004074c9                            # 004074bb
    # block 0x004074bd: entered by fall-through of jne at 0x004074bb, 2 instruction(s), ends with forward jump to 0x004074e8
    mov dword ptr [0x5e35c6], 0x0                # 004074bd
    jmp.d8 L_004074e8                            # 004074c7
L_004074c9:
    # block 0x004074c9: entered by jne at 0x004074bb, 4 instruction(s), ends with jne to 0x004074e8 (forward)
    mov dword ptr [0x5e35c6], 0x1                # 004074c9
    movsx eax, word ptr [0x5e335e]               # 004074d3
    cmp eax, 0x2f                                # 004074da
    jne.d8 L_004074e8                            # 004074dd
    # block 0x004074df: entered by fall-through of jne at 0x004074dd, 1 instruction(s), falls into the block at 0x004074e8
    mov word ptr [0x5e335e], 0xffff              # 004074df
L_004074e8:
    # block 0x004074e8: entered by jmp at 0x004074c7; jne at 0x004074dd, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004074e8
    call FUN_00404be1                            # 004074eb
    {load} mov esp, ebp                          # 004074f0
    pop ebp                                      # 004074f2
    ret                                          # 004074f3

