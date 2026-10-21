# FUN_00407773
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407773
# extent:       0x00407773-0x004077ba (71 code bytes)
# span:         0x00407773-0x004077ba (code 71, tables 0, padding 0)
# sha256:       3c8cbd49ae481ef86782f03e8fc6c31315ff5de739c5ec8d7b1eab642147c4e9
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m407773_toggle_5e35ee
# naming:       native port src/original_methods_fl37.c:m407773_toggle_5e35ee (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e35ee; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x39 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m407773_toggle_5e35ee (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00407773 - 0x401000
.globl FUN_00407773
FUN_00407773:
    # block 0x00407773: entry, 6 instruction(s), ends with jne to 0x0040778f (forward)
    push ebp                                     # 00407773
    {load} mov ebp, esp                          # 00407774
    push ecx                                     # 00407776
    mov dword ptr [ebp - local_4], ecx           # 00407777
    cmp dword ptr [0x5e35ee], 0x1                # 0040777a
    jne.d8 L_0040778f                            # 00407781
    # block 0x00407783: entered by fall-through of jne at 0x00407781, 2 instruction(s), ends with forward jump to 0x004077ae
    mov dword ptr [0x5e35ee], 0x0                # 00407783
    jmp.d8 L_004077ae                            # 0040778d
L_0040778f:
    # block 0x0040778f: entered by jne at 0x00407781, 4 instruction(s), ends with jne to 0x004077ae (forward)
    mov dword ptr [0x5e35ee], 0x1                # 0040778f
    movsx eax, word ptr [0x5e335e]               # 00407799
    cmp eax, 0x39                                # 004077a0
    jne.d8 L_004077ae                            # 004077a3
    # block 0x004077a5: entered by fall-through of jne at 0x004077a3, 1 instruction(s), falls into the block at 0x004077ae
    mov word ptr [0x5e335e], 0xffff              # 004077a5
L_004077ae:
    # block 0x004077ae: entered by jmp at 0x0040778d; jne at 0x004077a3, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004077ae
    call FUN_00404be1                            # 004077b1
    {load} mov esp, ebp                          # 004077b6
    pop ebp                                      # 004077b8
    ret                                          # 004077b9

