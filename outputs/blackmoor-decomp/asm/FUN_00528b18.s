# FUN_00528b18
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528b18
# extent:       0x00528b18-0x00528b27 (15 code bytes)
# span:         0x00528b18-0x00528b27 (code 15, tables 0, padding 0)
# sha256:       f23a4fa07c56a1d78d52cbf0ec02c319bcaa7725c06d61a26b060c6dbc2f005e
# evidence:     ev_d2c5fd8ee18803d4fcbad81aadf07f5107591d57975583e6b9ac0607df6e36be
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528b18
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004e1c83
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004e1c83, .text + (0x004e1c83 - 0x401000)

.org 0x00528b18 - 0x401000
.globl FUN_00528b18
FUN_00528b18:
    # block 0x00528b18: entry, 4 instruction(s), calls FUN_004e1c83, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00528b18
    add ecx, 0x31c                               # 00528b1b
    call FUN_004e1c83                            # 00528b21
    ret                                          # 00528b26

