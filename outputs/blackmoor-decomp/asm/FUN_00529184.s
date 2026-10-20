# FUN_00529184
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00529184
# extent:       0x00529184-0x0052918c (8 code bytes)
# span:         0x00529184-0x0052918c (code 8, tables 0, padding 0)
# sha256:       13872b7cd6d96394348a45163c3d3d644c921499448da1d7f7eaf623fe476d27
# evidence:     ev_103b446af90999e21d4e460ffaf2ca0eceda03f2ae40f017e023b1a6a4c96505
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00529184
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_c
# callees:      calls tail jump FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x0052918c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x00529184 - 0x401000
.globl FUN_00529184
FUN_00529184:
    # block 0x00529184: entry, 2 instruction(s), ends with backward jump to 0x0051e7ba
    lea ecx, [ebp + field_c]                     # 00529184
    jmp.d32 FUN_0051e7ba                         # 00529187

