# FUN_00447d10
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00447d10
# extent:       0x00447d10-0x00447d2f (31 code bytes)
# span:         0x00447d10-0x00447d2f (code 31, tables 0, padding 0)
# sha256:       ac9d4db0156ee886000ccbbf19b261b8812e2c44d47241780290835e06e84d83
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m447d10_init_vtable_call_ret_self
# naming:       native port src/original_methods_fl36c.c:m447d10_init_vtable_call_ret_self (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52cac8u at [this], calls 0x447d4b(this), returns this. No branch; all 12 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00447d4b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m447d10_init_vtable_call_ret_self (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00447d4b, .text + (0x00447d4b - 0x401000)

.org 0x00447d10 - 0x401000
.globl FUN_00447d10
FUN_00447d10:
    # block 0x00447d10: entry, 12 instruction(s), calls FUN_00447d4b, ends with ret
    push ebp                                     # 00447d10
    {load} mov ebp, esp                          # 00447d11
    push ecx                                     # 00447d13
    mov dword ptr [ebp - local_4], ecx           # 00447d14
    mov eax, dword ptr [ebp - local_4]           # 00447d17
    mov dword ptr [eax], 0x52cac8                # 00447d1a
    mov ecx, dword ptr [ebp - local_4]           # 00447d20
    call FUN_00447d4b                            # 00447d23
    mov eax, dword ptr [ebp - local_4]           # 00447d28
    {load} mov esp, ebp                          # 00447d2b
    pop ebp                                      # 00447d2d
    ret                                          # 00447d2e

