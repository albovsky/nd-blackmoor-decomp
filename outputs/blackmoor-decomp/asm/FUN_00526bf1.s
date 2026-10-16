# FUN_00526bf1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526bf1
# extent:       0x00526bf1-0x00526c00 (15 code bytes)
# span:         0x00526bf1-0x00526c00 (code 15, tables 0, padding 0)
# sha256:       33c61ca84a2abef5228c6b072989594f5d502b4f4a6d742692f3a43202a2fb16
# evidence:     ev_0bbbc573516b7688334fa3c5789e28ab705dc141b3b8d4358815cff5668572a9
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526bf1
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

.org 0x00526bf1 - 0x401000
.globl FUN_00526bf1
FUN_00526bf1:
    # block 0x00526bf1: entry, 4 instruction(s), calls FUN_00401032, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00526bf1
    add ecx, 0x38c                               # 00526bf4
    call FUN_00401032                            # 00526bfa
    ret                                          # 00526bff

