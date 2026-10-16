# FUN_00526ff9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526ff9
# extent:       0x00526ff9-0x00527008 (15 code bytes)
# span:         0x00526ff9-0x00527008 (code 15, tables 0, padding 0)
# sha256:       1baf69ed3047df6007acdb467276112a4e119161862fc4c9bbf632cd51600c57
# evidence:     ev_ece41028d6fef6bb0a900a8bf1bb6dcc384180be71ba7a9d527a5d7890f79415
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526ff9
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

.org 0x00526ff9 - 0x401000
.globl FUN_00526ff9
FUN_00526ff9:
    # block 0x00526ff9: entry, 4 instruction(s), calls FUN_00401032, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00526ff9
    add ecx, 0x8c                                # 00526ffc
    call FUN_00401032                            # 00527002
    ret                                          # 00527007

