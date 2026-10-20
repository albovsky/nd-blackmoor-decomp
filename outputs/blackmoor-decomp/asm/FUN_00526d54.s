# FUN_00526d54
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526d54
# extent:       0x00526d54-0x00526d5d (9 code bytes)
# span:         0x00526d54-0x00526d5d (code 9, tables 0, padding 0)
# sha256:       a71a059f7a25ce8d7a0f04f9902a6857c90de8955ac58a5c80b98bf8a6134696
# evidence:     ev_0bbbc573516b7688334fa3c5789e28ab705dc141b3b8d4358815cff5668572a9
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00526d54
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_005218ea
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x00526d5d
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_005218ea, .text + (0x005218ea - 0x401000)

.org 0x00526d54 - 0x401000
.globl FUN_00526d54
FUN_00526d54:
    # block 0x00526d54: entry, 3 instruction(s), calls FUN_005218ea, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00526d54
    call FUN_005218ea                            # 00526d57
    ret                                          # 00526d5c

