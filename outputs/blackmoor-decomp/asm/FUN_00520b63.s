# FUN_00520b63
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520b63
# extent:       0x00520b63-0x00520b68 (5 code bytes)
# span:         0x00520b63-0x00520b68 (code 5, tables 0, padding 0)
# sha256:       6f445fc48587796258de27044e3fbe4eb852c4fcf4382c8135884c1b5aafa385
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00520b14 (+0x4f)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520b63
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00520b63 - 0x401000
.globl FUN_00520b63
FUN_00520b63:
    # block 0x00520b63: entry, 2 instruction(s), ends with ret
    and dword ptr [ecx + field_4], 0x0           # 00520b63
    ret                                          # 00520b67

