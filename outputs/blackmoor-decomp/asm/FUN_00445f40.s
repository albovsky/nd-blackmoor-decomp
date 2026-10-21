# FUN_00445f40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00445f40
# extent:       0x00445f40-0x00445f53 (19 code bytes)
# span:         0x00445f40-0x00445f53 (code 19, tables 0, padding 0)
# sha256:       545264c5e0c4ef2ca4f20832273470506da8aee278cbf08737033c848cc1a3bf
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m445f40_forward_call
# naming:       native port src/original_methods_fl36e.c:m445f40_forward_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns 0x445e2b(this). No branch; all 9 instructions run. Nothing else is read or written.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00445e2b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m445f40_forward_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00445e2b, .text + (0x00445e2b - 0x401000)

.org 0x00445f40 - 0x401000
.globl FUN_00445f40
FUN_00445f40:
    # block 0x00445f40: entry, 9 instruction(s), calls FUN_00445e2b, ends with ret
    push ebp                                     # 00445f40
    {load} mov ebp, esp                          # 00445f41
    push ecx                                     # 00445f43
    mov dword ptr [ebp - local_4], ecx           # 00445f44
    mov ecx, dword ptr [ebp - local_4]           # 00445f47
    call FUN_00445e2b                            # 00445f4a
    {load} mov esp, ebp                          # 00445f4f
    pop ebp                                      # 00445f51
    ret                                          # 00445f52

