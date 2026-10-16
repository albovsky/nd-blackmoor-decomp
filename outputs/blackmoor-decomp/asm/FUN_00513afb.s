# FUN_00513afb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513afb
# extent:       0x00513afb-0x00513b02 (7 code bytes)
# span:         0x00513afb-0x00513b02 (code 7, tables 0, padding 0)
# sha256:       d6d08351d766f70d9b6c11cc1867e8baa26b5b0dd18b5dfe9cb3941ef9fd0491
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513a57 (+0xa4)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513afb
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00513b02
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00513afb - 0x401000
.globl FUN_00513afb
FUN_00513afb:
    # block 0x00513afb: entry, 4 instruction(s), ends with ret
    fstp st(0)                                   # 00513afb
    fstp st(0)                                   # 00513afd
    fld1                                         # 00513aff
    ret                                          # 00513b01

