# FUN_00528bc4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528bc4
# extent:       0x00528bc4-0x00528bcc (8 code bytes)
# span:         0x00528bc4-0x00528bcc (code 8, tables 0, padding 0)
# sha256:       3b2cfe74a0844affe2d3de92ba07cfe6305b91d69ef1cd49a2e64127c53fe71c
# evidence:     ev_d2c5fd8ee18803d4fcbad81aadf07f5107591d57975583e6b9ac0607df6e36be
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528bc4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_48
# callees:      calls tail jump FUN_0051b257
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00528bcc
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_48, 0x48  # offset -0x48

# --- external targets -----------------------------------------------
.set FUN_0051b257, .text + (0x0051b257 - 0x401000)

.org 0x00528bc4 - 0x401000
.globl FUN_00528bc4
FUN_00528bc4:
    # block 0x00528bc4: entry, 2 instruction(s), ends with backward jump to 0x0051b257
    lea ecx, [ebp - field_minus_48]              # 00528bc4
    jmp.d32 FUN_0051b257                         # 00528bc7

