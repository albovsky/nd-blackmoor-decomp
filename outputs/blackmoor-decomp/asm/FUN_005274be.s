# FUN_005274be
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005274be
# extent:       0x005274be-0x005274cd (15 code bytes)
# span:         0x005274be-0x005274cd (code 15, tables 0, padding 0)
# sha256:       31a6b6e3efe7d780bf1b5cf8d4b17ca08fb3f2f7a5e1642d708033a180a826ba
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@005274be
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00426346
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00426346, .text + (0x00426346 - 0x401000)

.org 0x005274be - 0x401000
.globl FUN_005274be
FUN_005274be:
    # block 0x005274be: entry, 4 instruction(s), calls FUN_00426346, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005274be
    add ecx, 0x135f1                             # 005274c1
    call FUN_00426346                            # 005274c7
    ret                                          # 005274cc

