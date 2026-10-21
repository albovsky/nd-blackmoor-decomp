# FUN_0044bea7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044bea7
# extent:       0x0044bea7-0x0044bebb (20 code bytes)
# span:         0x0044bea7-0x0044bebb (code 20, tables 0, padding 0)
# sha256:       1fec0ed5ec87a622b6424b45ee208b19cbeb9864b1781a2ccb62830b1f4bd5d7
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44bea7_init_vtable_ret_self
# naming:       native port src/original_methods_fl36e.c:m44bea7_init_vtable_ret_self (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52cbf0u at [this], returns this. No branch; all 9 instructions run. Nothing else is read or written.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m44bea7_init_vtable_ret_self (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0044bea7 - 0x401000
.globl FUN_0044bea7
FUN_0044bea7:
    # block 0x0044bea7: entry, 9 instruction(s), ends with ret
    push ebp                                     # 0044bea7
    {load} mov ebp, esp                          # 0044bea8
    push ecx                                     # 0044beaa
    mov dword ptr [ebp - local_4], ecx           # 0044beab
    mov eax, dword ptr [ebp - local_4]           # 0044beae
    mov dword ptr [eax], 0x52cbf0                # 0044beb1
    {load} mov esp, ebp                          # 0044beb7
    pop ebp                                      # 0044beb9
    ret                                          # 0044beba

