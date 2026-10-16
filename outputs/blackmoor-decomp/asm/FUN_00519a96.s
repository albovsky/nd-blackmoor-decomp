# FUN_00519a96
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519a96
# extent:       0x00519a96-0x00519aa9 (19 code bytes)
# span:         0x00519a96-0x00519aa9 (code 19, tables 0, padding 0)
# sha256:       5a795d38dd9d2c2e41c7b54e93f54076e6afce01acef389d9ad554668cd5a781
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00519a78 (+0x1e)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519a96
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00525c51, FUN_00525fac, tail jump FUN_00525c6b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00519aa9
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00525c51, .text + (0x00525c51 - 0x401000)
.set FUN_00525c6b, .text + (0x00525c6b - 0x401000)
.set FUN_00525fac, .text + (0x00525fac - 0x401000)

.org 0x00519a96 - 0x401000
.globl FUN_00519a96
FUN_00519a96:
    # block 0x00519a96: entry, 5 instruction(s), calls FUN_00525c51, FUN_00525fac, ends with forward jump to 0x00525c6b
    push 0x1                                     # 00519a96
    push 0x0                                     # 00519a98
    call FUN_00525c51                            # 00519a9a
    call FUN_00525fac                            # 00519a9f
    jmp.d32 FUN_00525c6b                         # 00519aa4

