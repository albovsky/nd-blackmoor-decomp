# FUN_00513af4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513af4
# extent:       0x00513af4-0x00513afb (7 code bytes)
# span:         0x00513af4-0x00513afb (code 7, tables 0, padding 0)
# sha256:       ded8c9e4660670bcd7499da0525dfaa6827ce60e227ab2b4096857f1dc9ddaca
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513a57 (+0x9d)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513af4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00513afb
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00513af4 - 0x401000
.globl FUN_00513af4
FUN_00513af4:
    # block 0x00513af4: entry, 4 instruction(s), ends with ret
    fstp st(0)                                   # 00513af4
    fstp st(0)                                   # 00513af6
    fldz                                         # 00513af8
    ret                                          # 00513afa

