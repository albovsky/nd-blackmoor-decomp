# FUN_00528a5e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528a5e
# extent:       0x00528a5e-0x00528a67 (9 code bytes)
# span:         0x00528a5e-0x00528a67 (code 9, tables 0, padding 0)
# sha256:       4cccf4e66c1bbc09959f9c365ccefce6c963e8c861c6f7ce2867a38b5cdc99fc
# evidence:     ev_d2c5fd8ee18803d4fcbad81aadf07f5107591d57975583e6b9ac0607df6e36be
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528a5e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004eda7c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004eda7c, .text + (0x004eda7c - 0x401000)

.org 0x00528a5e - 0x401000
.globl FUN_00528a5e
FUN_00528a5e:
    # block 0x00528a5e: entry, 3 instruction(s), calls FUN_004eda7c, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00528a5e
    call FUN_004eda7c                            # 00528a61
    ret                                          # 00528a66

