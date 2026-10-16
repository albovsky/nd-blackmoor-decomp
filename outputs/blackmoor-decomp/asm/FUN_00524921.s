# FUN_00524921
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524921
# extent:       0x00524921-0x00524926 (5 code bytes)
# span:         0x00524921-0x00524926 (code 5, tables 0, padding 0)
# sha256:       4a4ec2fa09c6533479011c81c215d339651b1cfd28b6c696142ec5651fad3ae5
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00524901 (+0x20)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524921
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0051b257
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00524926
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051b257, .text + (0x0051b257 - 0x401000)

.org 0x00524921 - 0x401000
.globl FUN_00524921
FUN_00524921:
    # block 0x00524921: entry, 1 instruction(s), ends with backward jump to 0x0051b257
    jmp.d32 FUN_0051b257                         # 00524921

