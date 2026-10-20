# FUN_00528714
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528714
# extent:       0x00528714-0x0052871d (9 code bytes)
# span:         0x00528714-0x0052871d (code 9, tables 0, padding 0)
# sha256:       d2c13b28c1cb4028760b3744e6f28d2a4be66aa453074fae22ac784e41852ceb
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00528714
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x0052871d
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x00528714 - 0x401000
.globl FUN_00528714
FUN_00528714:
    # block 0x00528714: entry, 3 instruction(s), calls FUN_0051d730, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00528714
    call FUN_0051d730                            # 00528717
    ret                                          # 0052871c

