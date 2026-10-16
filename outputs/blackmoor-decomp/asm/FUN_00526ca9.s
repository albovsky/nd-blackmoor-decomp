# FUN_00526ca9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526ca9
# extent:       0x00526ca9-0x00526cb8 (15 code bytes)
# span:         0x00526ca9-0x00526cb8 (code 15, tables 0, padding 0)
# sha256:       2fbfabf9af3ddf7f9bc17fc659249f5e5c89f8813ae7b4683b7c2c41d7fb2360
# evidence:     ev_0bbbc573516b7688334fa3c5789e28ab705dc141b3b8d4358815cff5668572a9
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526ca9
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

.org 0x00526ca9 - 0x401000
.globl FUN_00526ca9
FUN_00526ca9:
    # block 0x00526ca9: entry, 4 instruction(s), calls FUN_00401032, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00526ca9
    add ecx, 0x28c                               # 00526cac
    call FUN_00401032                            # 00526cb2
    ret                                          # 00526cb7

