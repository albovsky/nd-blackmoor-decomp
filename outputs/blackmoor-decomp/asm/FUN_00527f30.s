# FUN_00527f30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527f30
# extent:       0x00527f30-0x00527f39 (9 code bytes)
# span:         0x00527f30-0x00527f39 (code 9, tables 0, padding 0)
# sha256:       9024b7ebaf061dde1f6a1dc580e43aa624a5601550c1e460c30f4e2684bb03be
# evidence:     ev_7a152dca5b4d4270e26c3d32ca1ad001d44bfc411ed4e2c4ce09c304a9d9da5d
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527f30
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_68
# callees:      calls FUN_0044af20
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00527f39
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_68, 0x68  # offset -0x68

# --- external targets -----------------------------------------------
.set FUN_0044af20, .text + (0x0044af20 - 0x401000)

.org 0x00527f30 - 0x401000
.globl FUN_00527f30
FUN_00527f30:
    # block 0x00527f30: entry, 3 instruction(s), calls FUN_0044af20, ends with ret
    lea ecx, [ebp - field_minus_68]              # 00527f30
    call FUN_0044af20                            # 00527f33
    ret                                          # 00527f38

