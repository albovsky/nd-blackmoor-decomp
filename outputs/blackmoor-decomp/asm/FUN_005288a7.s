# FUN_005288a7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005288a7
# extent:       0x005288a7-0x005288b0 (9 code bytes)
# span:         0x005288a7-0x005288b0 (code 9, tables 0, padding 0)
# sha256:       e610c44214bc67ae17f098683645e5ccb238d8c05103ee24435a4771cbc370a2
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005288a7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005288b0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x005288a7 - 0x401000
.globl FUN_005288a7
FUN_005288a7:
    # block 0x005288a7: entry, 3 instruction(s), calls FUN_0051d730, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005288a7
    call FUN_0051d730                            # 005288aa
    ret                                          # 005288af

