# FUN_00526d80
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526d80
# extent:       0x00526d80-0x00526d8a (10 code bytes)
# span:         0x00526d80-0x00526d8a (code 10, tables 0, padding 0)
# sha256:       20ceba6a37ba455cf5f71273729e0fc286820790449b65effa5540aba0540f51
# evidence:     ev_0bbbc573516b7688334fa3c5789e28ab705dc141b3b8d4358815cff5668572a9
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526d80
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_14
# callees:      calls FUN_00401c90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00526d8a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_00401c90, .text + (0x00401c90 - 0x401000)

.org 0x00526d80 - 0x401000
.globl FUN_00526d80
FUN_00526d80:
    # block 0x00526d80: entry, 4 instruction(s), calls FUN_00401c90, ends with ret
    mov eax, dword ptr [ebp - field_minus_14]    # 00526d80
    push eax                                     # 00526d83
    call FUN_00401c90                            # 00526d84
    ret                                          # 00526d89

