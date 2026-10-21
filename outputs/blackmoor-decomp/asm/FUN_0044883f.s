# FUN_0044883f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044883f
# extent:       0x0044883f-0x00448853 (20 code bytes)
# span:         0x0044883f-0x00448853 (code 20, tables 0, padding 0)
# sha256:       4d7e8fb0572f19f001ac17dfdeb79b3b868a5d81790852611609e587c3663a92
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44883f_init_vtable_ret_self
# naming:       native port src/original_methods_fl36e.c:m44883f_init_vtable_ret_self (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52cb58u at [this], returns this. No branch; all 9 instructions run. Nothing else is read or written.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m44883f_init_vtable_ret_self (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0044883f - 0x401000
.globl FUN_0044883f
FUN_0044883f:
    # block 0x0044883f: entry, 9 instruction(s), ends with ret
    push ebp                                     # 0044883f
    {load} mov ebp, esp                          # 00448840
    push ecx                                     # 00448842
    mov dword ptr [ebp - local_4], ecx           # 00448843
    mov eax, dword ptr [ebp - local_4]           # 00448846
    mov dword ptr [eax], 0x52cb58                # 00448849
    {load} mov esp, ebp                          # 0044884f
    pop ebp                                      # 00448851
    ret                                          # 00448852

