# FUN_00526a9c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526a9c
# extent:       0x00526a9c-0x00526aa8 (12 code bytes)
# span:         0x00526a9c-0x00526aa8 (code 12, tables 0, padding 0)
# sha256:       d54706e5ec46bee4c834811668b76c0f96409c3a354aed8974a79e60c49aec6a
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526a9c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_1964
# callees:      calls FUN_00408d49
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00526aa8
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1964, 0x1964  # offset -0x1964

# --- external targets -----------------------------------------------
.set FUN_00408d49, .text + (0x00408d49 - 0x401000)

.org 0x00526a9c - 0x401000
.globl FUN_00526a9c
FUN_00526a9c:
    # block 0x00526a9c: entry, 3 instruction(s), calls FUN_00408d49, ends with ret
    lea ecx, [ebp - field_minus_1964]            # 00526a9c
    call FUN_00408d49                            # 00526aa2
    ret                                          # 00526aa7

