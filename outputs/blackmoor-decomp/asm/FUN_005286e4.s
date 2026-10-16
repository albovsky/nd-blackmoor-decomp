# FUN_005286e4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005286e4
# extent:       0x005286e4-0x005286ed (9 code bytes)
# span:         0x005286e4-0x005286ed (code 9, tables 0, padding 0)
# sha256:       c0140c1436b92c18727c9ff2b8a87b0256e13c2d642df3caf00e3d47daef290a
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005286e4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005286ed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x005286e4 - 0x401000
.globl FUN_005286e4
FUN_005286e4:
    # block 0x005286e4: entry, 3 instruction(s), calls FUN_0051d730, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005286e4
    call FUN_0051d730                            # 005286e7
    ret                                          # 005286ec

