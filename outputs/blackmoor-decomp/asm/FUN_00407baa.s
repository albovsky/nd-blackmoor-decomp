# FUN_00407baa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407baa
# extent:       0x00407baa-0x00407bba (16 code bytes)
# span:         0x00407baa-0x00407bba (code 16, tables 0, padding 0)
# sha256:       a813d5a0b61a0bc750bab80ce26ea79d461be76a05cc605d1db96349ae209ad3
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m407baa_get_constant
# naming:       native port src/original_methods_fl36b.c:m407baa_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52bb28u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m407baa_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00407baa - 0x401000
.globl FUN_00407baa
FUN_00407baa:
    # block 0x00407baa: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00407baa
    {load} mov ebp, esp                          # 00407bab
    push ecx                                     # 00407bad
    mov dword ptr [ebp - local_4], ecx           # 00407bae
    mov eax, 0x52bb28                            # 00407bb1
    {load} mov esp, ebp                          # 00407bb6
    pop ebp                                      # 00407bb8
    ret                                          # 00407bb9

