# FUN_00526d94
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526d94
# extent:       0x00526d94-0x00526d9d (9 code bytes)
# span:         0x00526d94-0x00526d9d (code 9, tables 0, padding 0)
# sha256:       d9b977c3bb2b4f65c803ef14c003ea5137f53eb1d31510f0888a4fa0444e25c2
# evidence:     ev_0bbbc573516b7688334fa3c5789e28ab705dc141b3b8d4358815cff5668572a9
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526d94
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_005218ea
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_005218ea, .text + (0x005218ea - 0x401000)

.org 0x00526d94 - 0x401000
.globl FUN_00526d94
FUN_00526d94:
    # block 0x00526d94: entry, 3 instruction(s), calls FUN_005218ea, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00526d94
    call FUN_005218ea                            # 00526d97
    ret                                          # 00526d9c

