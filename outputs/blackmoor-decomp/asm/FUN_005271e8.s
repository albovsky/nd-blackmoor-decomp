# FUN_005271e8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005271e8
# extent:       0x005271e8-0x005271f7 (15 code bytes)
# span:         0x005271e8-0x005271f7 (code 15, tables 0, padding 0)
# sha256:       1fe934f7378c48fead9640164f46f1794dd19c6416b7b7fb281f4374de033fa3
# evidence:     ev_ece41028d6fef6bb0a900a8bf1bb6dcc384180be71ba7a9d527a5d7890f79415
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@005271e8
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00401032
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00401032, .text + (0x00401032 - 0x401000)

.org 0x005271e8 - 0x401000
.globl FUN_005271e8
FUN_005271e8:
    # block 0x005271e8: entry, 4 instruction(s), calls FUN_00401032, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005271e8
    add ecx, 0x8cc                               # 005271eb
    call FUN_00401032                            # 005271f1
    ret                                          # 005271f6

