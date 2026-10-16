# FUN_00528c20
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528c20
# extent:       0x00528c20-0x00528c29 (9 code bytes)
# span:         0x00528c20-0x00528c29 (code 9, tables 0, padding 0)
# sha256:       842e56f56b621a671bccbb20ff48df2f05daffebf93c4e91dfcd0df632c76b2c
# evidence:     ev_d2c5fd8ee18803d4fcbad81aadf07f5107591d57975583e6b9ac0607df6e36be
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528c20
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_005256fb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00528c29
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_005256fb, .text + (0x005256fb - 0x401000)

.org 0x00528c20 - 0x401000
.globl FUN_00528c20
FUN_00528c20:
    # block 0x00528c20: entry, 3 instruction(s), calls FUN_005256fb, ends with ret
    push dword ptr [ebp - field_minus_10]        # 00528c20
    call FUN_005256fb                            # 00528c23
    ret                                          # 00528c28

