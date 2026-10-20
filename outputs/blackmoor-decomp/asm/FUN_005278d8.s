# FUN_005278d8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005278d8
# extent:       0x005278d8-0x005278e7 (15 code bytes)
# span:         0x005278d8-0x005278e7 (code 15, tables 0, padding 0)
# sha256:       8e08200b293022ff2e21f5adb9d34b0a161752dcff2ab733a1b4e7fdf5fcab42
# evidence:     ev_b63e1118bba1204c7ea8b81c8fd34d19f989b1bf23170257a27495e3973a3a30
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@005278d8
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0041458b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x005278e7
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0041458b, .text + (0x0041458b - 0x401000)

.org 0x005278d8 - 0x401000
.globl FUN_005278d8
FUN_005278d8:
    # block 0x005278d8: entry, 4 instruction(s), calls FUN_0041458b, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005278d8
    add ecx, 0xc8253                             # 005278db
    call FUN_0041458b                            # 005278e1
    ret                                          # 005278e6

