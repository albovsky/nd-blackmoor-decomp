# FUN_00527842
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527842
# extent:       0x00527842-0x00527851 (15 code bytes)
# span:         0x00527842-0x00527851 (code 15, tables 0, padding 0)
# sha256:       b04d653983fe57012a431f96f07c85d33b1227b532d8fd9bb8c0470e4438c677
# evidence:     ev_b63e1118bba1204c7ea8b81c8fd34d19f989b1bf23170257a27495e3973a3a30
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527842
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00490547
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00490547, .text + (0x00490547 - 0x401000)

.org 0x00527842 - 0x401000
.globl FUN_00527842
FUN_00527842:
    # block 0x00527842: entry, 4 instruction(s), calls FUN_00490547, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527842
    add ecx, 0xc0712                             # 00527845
    call FUN_00490547                            # 0052784b
    ret                                          # 00527850

