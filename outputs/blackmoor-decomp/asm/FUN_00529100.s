# FUN_00529100
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00529100
# extent:       0x00529100-0x0052910a (10 code bytes)
# span:         0x00529100-0x0052910a (code 10, tables 0, padding 0)
# sha256:       8845d50254a05f725bc949e612eab7d59b0e1c05acda8bfb90262ab20f5521cc
# evidence:     ev_103b446af90999e21d4e460ffaf2ca0eceda03f2ae40f017e023b1a6a4c96505
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00529100
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8
# callees:      calls FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x0052910a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00529100 - 0x401000
.globl FUN_00529100
FUN_00529100:
    # block 0x00529100: entry, 4 instruction(s), calls FUN_0051dc6c, ends with ret
    push dword ptr [ebp + field_8]               # 00529100
    call FUN_0051dc6c                            # 00529103
    pop ecx                                      # 00529108
    ret                                          # 00529109

