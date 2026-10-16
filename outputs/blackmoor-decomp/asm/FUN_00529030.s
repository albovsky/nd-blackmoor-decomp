# FUN_00529030
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00529030
# extent:       0x00529030-0x0052903a (10 code bytes)
# span:         0x00529030-0x0052903a (code 10, tables 0, padding 0)
# sha256:       5e81eeaf73da372fe01843488e2ead86416bded57732e516f52f9c6d71c2ed57
# evidence:     ev_911401004da6a50fe2c6da2a1636d1d967e1d217200235f8b7d699d8e6aaea05
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00529030
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8
# callees:      calls FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x0052903a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00529030 - 0x401000
.globl FUN_00529030
FUN_00529030:
    # block 0x00529030: entry, 4 instruction(s), calls FUN_0051dc6c, ends with ret
    push dword ptr [ebp + field_8]               # 00529030
    call FUN_0051dc6c                            # 00529033
    pop ecx                                      # 00529038
    ret                                          # 00529039

