# FUN_00527250
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527250
# extent:       0x00527250-0x0052725c (12 code bytes)
# span:         0x00527250-0x0052725c (code 12, tables 0, padding 0)
# sha256:       fed74e3005ee54efb4fe4c281d93c8d9f50501985f9cb8b6b5a14060ab1db107
# evidence:     ev_ece41028d6fef6bb0a900a8bf1bb6dcc384180be71ba7a9d527a5d7890f79415
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527250
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004230d1
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052725c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004230d1, .text + (0x004230d1 - 0x401000)

.org 0x00527250 - 0x401000
.globl FUN_00527250
FUN_00527250:
    # block 0x00527250: entry, 4 instruction(s), calls FUN_004230d1, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527250
    add ecx, 0x2a                                # 00527253
    call FUN_004230d1                            # 00527256
    ret                                          # 0052725b

