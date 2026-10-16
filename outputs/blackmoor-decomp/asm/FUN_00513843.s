# FUN_00513843
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513843
# extent:       0x00513843-0x0051384a (7 code bytes)
# span:         0x00513843-0x0051384a (code 7, tables 0, padding 0)
# sha256:       c80b5f12370575503df33ce7e3f902d20264e38a928d912510a69a13bae93fee
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# ending:       fall-through into 0x0051384a (counted only bound together with the range it falls into, under the owner ruling of 2026-10-16)
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513843
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_2c8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; the code part is a fragment that falls through into 0x0051384a and is counted only bound together with that range (owner ruling of 2026-10-16); function ledger class partial_native is a native-touch record, not a counterpart claim
# note:         falls_through_to:0x0051384a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_2c8, 0x2c8  # offset -0x2c8

# --- external targets -----------------------------------------------

.org 0x00513843 - 0x401000
.globl FUN_00513843
FUN_00513843:
    # block 0x00513843: entry, 1 instruction(s), falls through into the entry at 0x0051384a, which is bound together with this one
    and byte ptr [ebp - field_minus_2c8], -0x2   # 00513843

