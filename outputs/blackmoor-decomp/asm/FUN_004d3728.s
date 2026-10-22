# FUN_004d3728
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3728
# extent:       0x004d3728-0x004d37af (135 code bytes)
# span:         0x004d3728-0x004d37af (code 135, tables 0, padding 0)
# sha256:       cc4c677ec70ad9f9fd32b67f336252342823f0ea6cea10bbd6170263eacb203f
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d3728_log_three
# naming:       native port src/original_methods_fl39e.c:m4d3728_log_three (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Two five-argument log calls 0x4c5377 and 0x4c5d4b (this 0x5cf659) with globals and string addresses read in the original order. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c5377, FUN_004c5d4b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39e.c:m4d3728_log_three (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 37 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x004d3728 - 0x401000
.globl FUN_004d3728
FUN_004d3728:
    # block 0x004d3728: entry, 26 instruction(s), calls FUN_004c5377, FUN_004c5d4b, ends with je to 0x004d37ad (forward)
    push ebp                                     # 004d3728
    {load} mov ebp, esp                          # 004d3729
    push 0x55a388                                # 004d372b
    mov eax, dword ptr [0x5d1963]                # 004d3730
    push eax                                     # 004d3735
    push 0x5b4e58                                # 004d3736
    mov ecx, dword ptr [0x5cf665]                # 004d373b
    push ecx                                     # 004d3741
    mov edx, dword ptr [0x5d03bb]                # 004d3742
    push edx                                     # 004d3748
    mov ecx, 0x5cf659                            # 004d3749
    call FUN_004c5377                            # 004d374e
    push 0x55a398                                # 004d3753
    mov eax, dword ptr [0x5d1963]                # 004d3758
    push eax                                     # 004d375d
    mov ecx, dword ptr [0x5d195f]                # 004d375e
    push ecx                                     # 004d3764
    mov edx, dword ptr [0x5cf665]                # 004d3765
    push edx                                     # 004d376b
    mov eax, dword ptr [0x5d195b]                # 004d376c
    push eax                                     # 004d3771
    mov ecx, 0x5cf659                            # 004d3772
    call FUN_004c5d4b                            # 004d3777
    movsx ecx, word ptr [0x5b4e8d]               # 004d377c
    test ecx, ecx                                # 004d3783
    je.d8 L_004d37ad                             # 004d3785
    # block 0x004d3787: entered by fall-through of je at 0x004d3785, 9 instruction(s), calls FUN_004c5d4b, falls into the block at 0x004d37ad
    push 0x55a3a8                                # 004d3787
    push 0x5b4e48                                # 004d378c
    push 0x5b4e38                                # 004d3791
    mov edx, dword ptr [0x5cf665]                # 004d3796
    push edx                                     # 004d379c
    mov eax, dword ptr [0x5d03c7]                # 004d379d
    push eax                                     # 004d37a2
    mov ecx, 0x5cf659                            # 004d37a3
    call FUN_004c5d4b                            # 004d37a8
L_004d37ad:
    # block 0x004d37ad: entered by je at 0x004d3785, 2 instruction(s), ends with ret
    pop ebp                                      # 004d37ad
    ret                                          # 004d37ae

