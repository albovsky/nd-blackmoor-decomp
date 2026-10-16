# FUN_00527215
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527215
# extent:       0x00527215-0x00527224 (15 code bytes)
# span:         0x00527215-0x00527224 (code 15, tables 0, padding 0)
# sha256:       fae2781bd458c3abd5e23c43f1461b49dff487be82ecd7bd12a770ee4245a0fc
# evidence:     ev_ece41028d6fef6bb0a900a8bf1bb6dcc384180be71ba7a9d527a5d7890f79415
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527215
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00401032
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00401032, .text + (0x00401032 - 0x401000)

.org 0x00527215 - 0x401000
.globl FUN_00527215
FUN_00527215:
    # block 0x00527215: entry, 4 instruction(s), calls FUN_00401032, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527215
    add ecx, 0x98c                               # 00527218
    call FUN_00401032                            # 0052721e
    ret                                          # 00527223

