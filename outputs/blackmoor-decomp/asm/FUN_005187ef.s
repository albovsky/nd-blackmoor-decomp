# FUN_005187ef
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005187ef
# extent:       0x005187ef-0x005187f5 (6 code bytes)
# span:         0x005187ef-0x005187f5 (code 6, tables 0, padding 0)
# sha256:       7b2dfb50e571bbe217c9bd7b7f09fb0290fefe30161e5a58d5ec4329aaccc56e
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051779c (+0x1053)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005187ef
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00518734
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005187f5
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00518734, .text + (0x00518734 - 0x401000)

.org 0x005187ef - 0x401000
.globl FUN_005187ef
FUN_005187ef:
    # block 0x005187ef: entry, 2 instruction(s), calls FUN_00518734, ends with ret
    call FUN_00518734                            # 005187ef
    ret                                          # 005187f4

