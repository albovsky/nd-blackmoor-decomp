# FUN_005287db
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005287db
# extent:       0x005287db-0x005287ea (15 code bytes)
# span:         0x005287db-0x005287ea (code 15, tables 0, padding 0)
# sha256:       749751b749754dc33eb3a77e942ad0e8b2d85fbe8c149d49c71f72fdae7ac0ab
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005287db
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_18
# callees:      calls FUN_0043ef27
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005287ea
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_0043ef27, .text + (0x0043ef27 - 0x401000)

.org 0x005287db - 0x401000
.globl FUN_005287db
FUN_005287db:
    # block 0x005287db: entry, 4 instruction(s), calls FUN_0043ef27, ends with ret
    mov ecx, dword ptr [ebp - field_minus_18]    # 005287db
    add ecx, 0x38cc                              # 005287de
    call FUN_0043ef27                            # 005287e4
    ret                                          # 005287e9

