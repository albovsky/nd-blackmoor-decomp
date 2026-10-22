# FUN_0043d7c4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043d7c4
# extent:       0x0043d7c4-0x0043d7f0 (44 code bytes)
# span:         0x0043d7c4-0x0043d7f0 (code 44, tables 0, padding 0)
# sha256:       47d2928538ffe6af29e081f4ba00e136e8b2f1b393cfb8d9b43adfa5461ed049
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m43d7c4_lifted
# naming:       native port src/original_methods_fl40.c:m43d7c4_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 2 seeds; oracle 15/15 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ddb9, FUN_0050dc53
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m43d7c4_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 15 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050dc53, .text + (0x0050dc53 - 0x401000)
.set FUN_0050ddb9, .text + (0x0050ddb9 - 0x401000)

.org 0x0043d7c4 - 0x401000
.globl FUN_0043d7c4
FUN_0043d7c4:
    # block 0x0043d7c4: entry, 15 instruction(s), calls FUN_0050ddb9, FUN_0050dc53, ends with ret
    push ebp                                     # 0043d7c4
    {load} mov ebp, esp                          # 0043d7c5
    mov eax, dword ptr [ebp + arg_8]             # 0043d7c7
    push eax                                     # 0043d7ca
    push 0x54763c                                # 0043d7cb
    mov ecx, dword ptr [0x63a4f1]                # 0043d7d0
    push ecx                                     # 0043d7d6
    call FUN_0050ddb9                            # 0043d7d7
    add esp, 0xc                                 # 0043d7dc
    mov edx, dword ptr [0x63a4f1]                # 0043d7df
    push edx                                     # 0043d7e5
    call FUN_0050dc53                            # 0043d7e6
    add esp, 0x4                                 # 0043d7eb
    pop ebp                                      # 0043d7ee
    ret                                          # 0043d7ef

