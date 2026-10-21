# FUN_004ac85a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ac85a
# extent:       0x004ac85a-0x004ac86a (16 code bytes)
# span:         0x004ac85a-0x004ac86a (code 16, tables 0, padding 0)
# sha256:       c10aea4b63f7a55b3d906f24738996b1d0b8ab190c93928e5ddb662ec1d79052
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ac85a_get_constant
# naming:       native port src/original_methods_fl36b.c:m4ac85a_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52df50u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m4ac85a_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004ac85a - 0x401000
.globl FUN_004ac85a
FUN_004ac85a:
    # block 0x004ac85a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004ac85a
    {load} mov ebp, esp                          # 004ac85b
    push ecx                                     # 004ac85d
    mov dword ptr [ebp - local_4], ecx           # 004ac85e
    mov eax, 0x52df50                            # 004ac861
    {load} mov esp, ebp                          # 004ac866
    pop ebp                                      # 004ac868
    ret                                          # 004ac869

