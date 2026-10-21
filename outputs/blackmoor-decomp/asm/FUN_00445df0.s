# FUN_00445df0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00445df0
# extent:       0x00445df0-0x00445e0f (31 code bytes)
# span:         0x00445df0-0x00445e0f (code 31, tables 0, padding 0)
# sha256:       d27d975e3110ffb36077f8adcd68ba4a13d28d41141850072eed16cf04580378
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m445df0_init_vtable_call_ret_self
# naming:       native port src/original_methods_fl36c.c:m445df0_init_vtable_call_ret_self (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52ca1cu at [this], calls 0x445e2b(this), returns this. No branch; all 12 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00445e2b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m445df0_init_vtable_call_ret_self (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00445e2b, .text + (0x00445e2b - 0x401000)

.org 0x00445df0 - 0x401000
.globl FUN_00445df0
FUN_00445df0:
    # block 0x00445df0: entry, 12 instruction(s), calls FUN_00445e2b, ends with ret
    push ebp                                     # 00445df0
    {load} mov ebp, esp                          # 00445df1
    push ecx                                     # 00445df3
    mov dword ptr [ebp - local_4], ecx           # 00445df4
    mov eax, dword ptr [ebp - local_4]           # 00445df7
    mov dword ptr [eax], 0x52ca1c                # 00445dfa
    mov ecx, dword ptr [ebp - local_4]           # 00445e00
    call FUN_00445e2b                            # 00445e03
    mov eax, dword ptr [ebp - local_4]           # 00445e08
    {load} mov esp, ebp                          # 00445e0b
    pop ebp                                      # 00445e0d
    ret                                          # 00445e0e

