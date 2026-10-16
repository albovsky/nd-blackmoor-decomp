# FUN_00528bf8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528bf8
# extent:       0x00528bf8-0x00528c02 (10 code bytes)
# span:         0x00528bf8-0x00528c02 (code 10, tables 0, padding 0)
# sha256:       1a46634bc378b91f41fcba1af70a11c5f5978786482849f84dad4c78168ea877
# evidence:     ev_d2c5fd8ee18803d4fcbad81aadf07f5107591d57975583e6b9ac0607df6e36be
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528bf8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0051d43c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00528c02
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051d43c, .text + (0x0051d43c - 0x401000)

.org 0x00528bf8 - 0x401000
.globl FUN_00528bf8
FUN_00528bf8:
    # block 0x00528bf8: entry, 4 instruction(s), calls FUN_0051d43c, ends with ret
    push dword ptr [ebp - field_minus_10]        # 00528bf8
    call FUN_0051d43c                            # 00528bfb
    pop ecx                                      # 00528c00
    ret                                          # 00528c01

