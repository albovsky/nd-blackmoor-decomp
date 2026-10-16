# FUN_005187e9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005187e9
# extent:       0x005187e9-0x005187ef (6 code bytes)
# span:         0x005187e9-0x005187ef (code 6, tables 0, padding 0)
# sha256:       f0d49b9df9830ccf700c7b8d7e44dbe7c23d14b80328fff3a214143095cde63f
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051779c (+0x104d)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005187e9
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051847c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005187ef
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051847c, .text + (0x0051847c - 0x401000)

.org 0x005187e9 - 0x401000
.globl FUN_005187e9
FUN_005187e9:
    # block 0x005187e9: entry, 2 instruction(s), calls FUN_0051847c, ends with ret
    call FUN_0051847c                            # 005187e9
    ret                                          # 005187ee

