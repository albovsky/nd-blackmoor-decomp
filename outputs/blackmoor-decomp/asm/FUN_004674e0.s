# FUN_004674e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004674e0
# extent:       0x004674e0-0x004674ff (31 code bytes)
# span:         0x004674e0-0x004674ff (code 31, tables 0, padding 0)
# sha256:       d676c888b33a3761de7f38704a97eaa747da1d4567aeba5ebfd93a62fe3c32c4
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4674e0_init_vtable_call_ret_self
# naming:       native port src/original_methods_fl36c.c:m4674e0_init_vtable_call_ret_self (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52d1e0u at [this], calls 0x467513(this), returns this. No branch; all 12 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00467513
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m4674e0_init_vtable_call_ret_self (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00467513, .text + (0x00467513 - 0x401000)

.org 0x004674e0 - 0x401000
.globl FUN_004674e0
FUN_004674e0:
    # block 0x004674e0: entry, 12 instruction(s), calls FUN_00467513, ends with ret
    push ebp                                     # 004674e0
    {load} mov ebp, esp                          # 004674e1
    push ecx                                     # 004674e3
    mov dword ptr [ebp - local_4], ecx           # 004674e4
    mov eax, dword ptr [ebp - local_4]           # 004674e7
    mov dword ptr [eax], 0x52d1e0                # 004674ea
    mov ecx, dword ptr [ebp - local_4]           # 004674f0
    call FUN_00467513                            # 004674f3
    mov eax, dword ptr [ebp - local_4]           # 004674f8
    {load} mov esp, ebp                          # 004674fb
    pop ebp                                      # 004674fd
    ret                                          # 004674fe

