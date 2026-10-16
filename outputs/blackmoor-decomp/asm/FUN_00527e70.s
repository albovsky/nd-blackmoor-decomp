# FUN_00527e70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527e70
# extent:       0x00527e70-0x00527e7c (12 code bytes)
# span:         0x00527e70-0x00527e7c (code 12, tables 0, padding 0)
# sha256:       18c980f51e7b9effce35779b8859cd3b11bdb1ad875d40b956f305e6641e53b4
# evidence:     ev_630eb8c9c6330d8d8954b0f0603252a92e8f72ed7f378cfbde79d9e20ec97ca4
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527e70
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_6088
# callees:      calls FUN_00433e63
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00527e7c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_6088, 0x6088  # offset -0x6088

# --- external targets -----------------------------------------------
.set FUN_00433e63, .text + (0x00433e63 - 0x401000)

.org 0x00527e70 - 0x401000
.globl FUN_00527e70
FUN_00527e70:
    # block 0x00527e70: entry, 3 instruction(s), calls FUN_00433e63, ends with ret
    lea ecx, [ebp - field_minus_6088]            # 00527e70
    call FUN_00433e63                            # 00527e76
    ret                                          # 00527e7b

