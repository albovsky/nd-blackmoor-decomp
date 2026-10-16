# FUN_00526ae7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526ae7
# extent:       0x00526ae7-0x00526af3 (12 code bytes)
# span:         0x00526ae7-0x00526af3 (code 12, tables 0, padding 0)
# sha256:       d4da523cbf0c6dda996661dd72b13b3ede43434be9e0ae8a6c18471fc5b5ad42
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526ae7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_ec
# callees:      calls FUN_00401c70
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00526af3
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_ec, 0xec  # offset -0xec

# --- external targets -----------------------------------------------
.set FUN_00401c70, .text + (0x00401c70 - 0x401000)

.org 0x00526ae7 - 0x401000
.globl FUN_00526ae7
FUN_00526ae7:
    # block 0x00526ae7: entry, 3 instruction(s), calls FUN_00401c70, ends with ret
    lea ecx, [ebp - field_minus_ec]              # 00526ae7
    call FUN_00401c70                            # 00526aed
    ret                                          # 00526af2

