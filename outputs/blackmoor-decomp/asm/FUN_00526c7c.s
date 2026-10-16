# FUN_00526c7c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526c7c
# extent:       0x00526c7c-0x00526c8b (15 code bytes)
# span:         0x00526c7c-0x00526c8b (code 15, tables 0, padding 0)
# sha256:       3f5e1779ec6bde158538f0b01ee179025e5cb5b91f7d865506ab3107a57c3fff
# evidence:     ev_0bbbc573516b7688334fa3c5789e28ab705dc141b3b8d4358815cff5668572a9
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526c7c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
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

.org 0x00526c7c - 0x401000
.globl FUN_00526c7c
FUN_00526c7c:
    # block 0x00526c7c: entry, 4 instruction(s), calls FUN_00401032, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00526c7c
    add ecx, 0x1cc                               # 00526c7f
    call FUN_00401032                            # 00526c85
    ret                                          # 00526c8a

