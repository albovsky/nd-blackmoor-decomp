# FUN_005287b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005287b0
# extent:       0x005287b0-0x005287b9 (9 code bytes)
# span:         0x005287b0-0x005287b9 (code 9, tables 0, padding 0)
# sha256:       55bd60c9e452c97d51cb6b84ab8609188e4227b0eeb248dc2e9dc8b40e8d4743
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@005287b0
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_1c
# callees:      calls FUN_004caec0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1c, 0x1c  # offset -0x1c

# --- external targets -----------------------------------------------
.set FUN_004caec0, .text + (0x004caec0 - 0x401000)

.org 0x005287b0 - 0x401000
.globl FUN_005287b0
FUN_005287b0:
    # block 0x005287b0: entry, 3 instruction(s), calls FUN_004caec0, ends with ret
    mov ecx, dword ptr [ebp - field_minus_1c]    # 005287b0
    call FUN_004caec0                            # 005287b3
    ret                                          # 005287b8

