# FUN_0043ef10
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043ef10
# extent:       0x0043ef10-0x0043ef27 (23 code bytes)
# span:         0x0043ef10-0x0043ef27 (code 23, tables 0, padding 0)
# sha256:       65975bdaf226db806bcf381a903ca94f54f3763d34d8c68cc8902b466010825d
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m43ef10_init_vtable_ret_self
# naming:       native port src/original_methods_fl36e.c:m43ef10_init_vtable_ret_self (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52ca10u at [this], returns this. No branch; all 10 instructions run. Nothing else is read or written.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m43ef10_init_vtable_ret_self (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0043ef10 - 0x401000
.globl FUN_0043ef10
FUN_0043ef10:
    # block 0x0043ef10: entry, 10 instruction(s), ends with ret
    push ebp                                     # 0043ef10
    {load} mov ebp, esp                          # 0043ef11
    push ecx                                     # 0043ef13
    mov dword ptr [ebp - local_4], ecx           # 0043ef14
    mov eax, dword ptr [ebp - local_4]           # 0043ef17
    mov dword ptr [eax], 0x52ca10                # 0043ef1a
    mov eax, dword ptr [ebp - local_4]           # 0043ef20
    {load} mov esp, ebp                          # 0043ef23
    pop ebp                                      # 0043ef25
    ret                                          # 0043ef26

