# FUN_00528b27
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528b27
# extent:       0x00528b27-0x00528b36 (15 code bytes)
# span:         0x00528b27-0x00528b36 (code 15, tables 0, padding 0)
# sha256:       bab27bf75ad95e87b27c5e6cc49c9bc5f9692816515f3778ee5e5d0d85e32dbc
# evidence:     ev_d2c5fd8ee18803d4fcbad81aadf07f5107591d57975583e6b9ac0607df6e36be
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00528b27
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004ee99f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x00528b36
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004ee99f, .text + (0x004ee99f - 0x401000)

.org 0x00528b27 - 0x401000
.globl FUN_00528b27
FUN_00528b27:
    # block 0x00528b27: entry, 4 instruction(s), calls FUN_004ee99f, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00528b27
    add ecx, 0x4b7                               # 00528b2a
    call FUN_004ee99f                            # 00528b30
    ret                                          # 00528b35

