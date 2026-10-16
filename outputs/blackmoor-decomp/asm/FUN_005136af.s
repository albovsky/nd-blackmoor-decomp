# FUN_005136af
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005136af
# extent:       0x005136af-0x005136c1 (18 code bytes)
# span:         0x005136af-0x005136c1 (code 18, tables 0, padding 0)
# sha256:       593d7f0d83f2b14cfcdc3427d0d1717fa72f8ef2f3ed24fb7cd9dc2ff4b356dd
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513546 (+0x169)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005136af
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_90
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005136c1
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_90, 0x90  # offset -0x90

# --- external targets -----------------------------------------------

.org 0x005136af - 0x401000
.globl FUN_005136af
FUN_005136af:
    # block 0x005136af: entry, 5 instruction(s), ends with ret
    fstp st(0)                                   # 005136af
    fstp st(0)                                   # 005136b1
    fld tbyte ptr [0x5688b0]                     # 005136b3
    mov byte ptr [ebp - field_minus_90], 0x3     # 005136b9
    ret                                          # 005136c0

