# FUN_00528be4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528be4
# extent:       0x00528be4-0x00528bed (9 code bytes)
# span:         0x00528be4-0x00528bed (code 9, tables 0, padding 0)
# sha256:       44df9d4fb99831f2442a03de96bd869abc886150fc63b4ef5c449c81e6ae39bd
# evidence:     ev_d2c5fd8ee18803d4fcbad81aadf07f5107591d57975583e6b9ac0607df6e36be
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00528be4
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00401c90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x00528bed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00401c90, .text + (0x00401c90 - 0x401000)

.org 0x00528be4 - 0x401000
.globl FUN_00528be4
FUN_00528be4:
    # block 0x00528be4: entry, 3 instruction(s), calls FUN_00401c90, ends with ret
    push dword ptr [ebp - field_minus_10]        # 00528be4
    call FUN_00401c90                            # 00528be7
    ret                                          # 00528bec

