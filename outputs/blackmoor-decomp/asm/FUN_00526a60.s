# FUN_00526a60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526a60
# extent:       0x00526a60-0x00526a6c (12 code bytes)
# span:         0x00526a60-0x00526a6c (code 12, tables 0, padding 0)
# sha256:       4cf7f92023904ee948e7f9291804bbdbb33f2c28717a13caedd68459932d84c0
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00526a60
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_ed8
# callees:      calls FUN_00521fa5
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_ed8, 0xed8  # offset -0xed8

# --- external targets -----------------------------------------------
.set FUN_00521fa5, .text + (0x00521fa5 - 0x401000)

.org 0x00526a60 - 0x401000
.globl FUN_00526a60
FUN_00526a60:
    # block 0x00526a60: entry, 3 instruction(s), calls FUN_00521fa5, ends with ret
    lea ecx, [ebp - field_minus_ed8]             # 00526a60
    call FUN_00521fa5                            # 00526a66
    ret                                          # 00526a6b

