# FUN_00526a90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526a90
# extent:       0x00526a90-0x00526a9c (12 code bytes)
# span:         0x00526a90-0x00526a9c (code 12, tables 0, padding 0)
# sha256:       88648144ba1a2c1420e7a62e6158414688b04b5f6c785e2d8d5df3b67de7c7b4
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00526a90
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_27d0
# callees:      calls FUN_004014f5
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_27d0, 0x27d0  # offset -0x27d0

# --- external targets -----------------------------------------------
.set FUN_004014f5, .text + (0x004014f5 - 0x401000)

.org 0x00526a90 - 0x401000
.globl FUN_00526a90
FUN_00526a90:
    # block 0x00526a90: entry, 3 instruction(s), calls FUN_004014f5, ends with ret
    lea ecx, [ebp - field_minus_27d0]            # 00526a90
    call FUN_004014f5                            # 00526a96
    ret                                          # 00526a9b

