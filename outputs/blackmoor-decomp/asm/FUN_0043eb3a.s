# FUN_0043eb3a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043eb3a
# extent:       0x0043eb3a-0x0043eb59 (31 code bytes)
# span:         0x0043eb3a-0x0043eb59 (code 31, tables 0, padding 0)
# sha256:       83ba6dcfb42a688ddff6145f1baa5b509580efa96838ff9cb16fd5a5860c9a10
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m43eb3a_destruct_base_set_vtable
# naming:       native port src/original_methods_fl36e.c:m43eb3a_destruct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x5227c6(this), then stores 0x52c900u at [this], returns this. No branch; all 12 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005227c6
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m43eb3a_destruct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_005227c6, .text + (0x005227c6 - 0x401000)

.org 0x0043eb3a - 0x401000
.globl FUN_0043eb3a
FUN_0043eb3a:
    # block 0x0043eb3a: entry, 12 instruction(s), calls FUN_005227c6, ends with ret
    push ebp                                     # 0043eb3a
    {load} mov ebp, esp                          # 0043eb3b
    push ecx                                     # 0043eb3d
    mov dword ptr [ebp - local_4], ecx           # 0043eb3e
    mov ecx, dword ptr [ebp - local_4]           # 0043eb41
    call FUN_005227c6                            # 0043eb44
    mov eax, dword ptr [ebp - local_4]           # 0043eb49
    mov dword ptr [eax], 0x52c900                # 0043eb4c
    mov eax, dword ptr [ebp - local_4]           # 0043eb52
    {load} mov esp, ebp                          # 0043eb55
    pop ebp                                      # 0043eb57
    ret                                          # 0043eb58

