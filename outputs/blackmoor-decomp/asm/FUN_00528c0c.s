# FUN_00528c0c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528c0c
# extent:       0x00528c0c-0x00528c15 (9 code bytes)
# span:         0x00528c0c-0x00528c15 (code 9, tables 0, padding 0)
# sha256:       6066fed7719c2057142515429461160ee13ae9ba3072bc27bc0d06973c43daae
# evidence:     ev_d2c5fd8ee18803d4fcbad81aadf07f5107591d57975583e6b9ac0607df6e36be
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528c0c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_005256fb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00528c15
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_005256fb, .text + (0x005256fb - 0x401000)

.org 0x00528c0c - 0x401000
.globl FUN_00528c0c
FUN_00528c0c:
    # block 0x00528c0c: entry, 3 instruction(s), calls FUN_005256fb, ends with ret
    push dword ptr [ebp - field_minus_10]        # 00528c0c
    call FUN_005256fb                            # 00528c0f
    ret                                          # 00528c14

