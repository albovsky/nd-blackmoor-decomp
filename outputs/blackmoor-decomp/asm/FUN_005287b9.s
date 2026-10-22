# FUN_005287b9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005287b9
# extent:       0x005287b9-0x005287c8 (15 code bytes)
# span:         0x005287b9-0x005287c8 (code 15, tables 0, padding 0)
# sha256:       3f398aa225848f03d1e8889bbb0c22392ce5b98f2c7e41aba77117d9bbf5ee70
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@005287b9
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_1c
# callees:      calls FUN_0043ef27
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x005287c8
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1c, 0x1c  # offset -0x1c

# --- external targets -----------------------------------------------
.set FUN_0043ef27, .text + (0x0043ef27 - 0x401000)

.org 0x005287b9 - 0x401000
.globl FUN_005287b9
FUN_005287b9:
    # block 0x005287b9: entry, 4 instruction(s), calls FUN_0043ef27, ends with ret
    mov ecx, dword ptr [ebp - field_minus_1c]    # 005287b9
    add ecx, 0x38cc                              # 005287bc
    call FUN_0043ef27                            # 005287c2
    ret                                          # 005287c7

