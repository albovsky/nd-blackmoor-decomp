# FUN_0051b4a8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b4a8
# extent:       0x0051b4a8-0x0051b4ac (4 code bytes)
# span:         0x0051b4a8-0x0051b4ac (code 4, tables 0, padding 0)
# sha256:       84820c9f74a607947a808a1567dcf68506f79bdd5cb57fd2d8af148e5c8c05b7
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051b461 (+0x47)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b4a8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_28
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------

.org 0x0051b4a8 - 0x401000
.globl FUN_0051b4a8
FUN_0051b4a8:
    # block 0x0051b4a8: entry, 2 instruction(s), ends with ret
    lea eax, [ecx + field_28]                    # 0051b4a8
    ret                                          # 0051b4ab

