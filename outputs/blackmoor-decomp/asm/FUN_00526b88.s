# FUN_00526b88
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526b88
# extent:       0x00526b88-0x00526b97 (15 code bytes)
# span:         0x00526b88-0x00526b97 (code 15, tables 0, padding 0)
# sha256:       42676e56a8f0d809ea4500e5d2c95bc601467ad8a069e6d4be25499765a32942
# evidence:     ev_0bbbc573516b7688334fa3c5789e28ab705dc141b3b8d4358815cff5668572a9
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526b88
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

.org 0x00526b88 - 0x401000
.globl FUN_00526b88
FUN_00526b88:
    # block 0x00526b88: entry, 4 instruction(s), calls FUN_00401032, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00526b88
    add ecx, 0x1cc                               # 00526b8b
    call FUN_00401032                            # 00526b91
    ret                                          # 00526b96

