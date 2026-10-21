# FUN_00437710
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00437710
# extent:       0x00437710-0x0043772f (31 code bytes)
# span:         0x00437710-0x0043772f (code 31, tables 0, padding 0)
# sha256:       1f5ddc65d856f4e27e6dc076d07ee182524d38934316a2f3529065e378c50347
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m437710_init_vtable_call_ret_self
# naming:       native port src/original_methods_fl36c.c:m437710_init_vtable_call_ret_self (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52c7bcu at [this], calls 0x437743(this), returns this. No branch; all 12 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00437743
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m437710_init_vtable_call_ret_self (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00437743, .text + (0x00437743 - 0x401000)

.org 0x00437710 - 0x401000
.globl FUN_00437710
FUN_00437710:
    # block 0x00437710: entry, 12 instruction(s), calls FUN_00437743, ends with ret
    push ebp                                     # 00437710
    {load} mov ebp, esp                          # 00437711
    push ecx                                     # 00437713
    mov dword ptr [ebp - local_4], ecx           # 00437714
    mov eax, dword ptr [ebp - local_4]           # 00437717
    mov dword ptr [eax], 0x52c7bc                # 0043771a
    mov ecx, dword ptr [ebp - local_4]           # 00437720
    call FUN_00437743                            # 00437723
    mov eax, dword ptr [ebp - local_4]           # 00437728
    {load} mov esp, ebp                          # 0043772b
    pop ebp                                      # 0043772d
    ret                                          # 0043772e

