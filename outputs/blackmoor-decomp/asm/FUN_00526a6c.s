# FUN_00526a6c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526a6c
# extent:       0x00526a6c-0x00526a78 (12 code bytes)
# span:         0x00526a6c-0x00526a78 (code 12, tables 0, padding 0)
# sha256:       8469f572ad1b78a9bce22ee58a4c1b69c141c58b47aa66f47641ba3525f5a5d8
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00526a6c
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_998
# callees:      calls FUN_00407c29
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_998, 0x998  # offset -0x998

# --- external targets -----------------------------------------------
.set FUN_00407c29, .text + (0x00407c29 - 0x401000)

.org 0x00526a6c - 0x401000
.globl FUN_00526a6c
FUN_00526a6c:
    # block 0x00526a6c: entry, 3 instruction(s), calls FUN_00407c29, ends with ret
    lea ecx, [ebp - field_minus_998]             # 00526a6c
    call FUN_00407c29                            # 00526a72
    ret                                          # 00526a77

