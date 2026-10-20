# FUN_00526afd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526afd
# extent:       0x00526afd-0x00526b09 (12 code bytes)
# span:         0x00526afd-0x00526b09 (code 12, tables 0, padding 0)
# sha256:       52021727d1dee0947fb66ee28d899616870e2ae426a7a4e690e46b5e7a5b5aae
# evidence:     ev_0bbbc573516b7688334fa3c5789e28ab705dc141b3b8d4358815cff5668572a9
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00526afd
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_ec
# callees:      calls FUN_00401c70
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x00526b09
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_ec, 0xec  # offset -0xec

# --- external targets -----------------------------------------------
.set FUN_00401c70, .text + (0x00401c70 - 0x401000)

.org 0x00526afd - 0x401000
.globl FUN_00526afd
FUN_00526afd:
    # block 0x00526afd: entry, 3 instruction(s), calls FUN_00401c70, ends with ret
    lea ecx, [ebp - field_minus_ec]              # 00526afd
    call FUN_00401c70                            # 00526b03
    ret                                          # 00526b08

